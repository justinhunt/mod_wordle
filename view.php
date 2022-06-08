<?php

// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Wordle module version information
 *
 * @package mod_wordle
 * @copyright  2009 Petr Skoda (http://skodak.org)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require('../../config.php');
require_once($CFG->dirroot.'/mod/wordle/lib.php');
require_once($CFG->dirroot.'/mod/wordle/locallib.php');
require_once($CFG->libdir.'/completionlib.php');

$id      = optional_param('id', 0, PARAM_INT); // Course Module ID
$p       = optional_param('p', 0, PARAM_INT);  // Wordle instance ID
$inpopup = optional_param('inpopup', 0, PARAM_BOOL);

if ($p) {
    if (!$wordle = $DB->get_record('wordle', array('id'=>$p))) {
        print_error('invalidaccessparameter');
    }
    $cm = get_coursemodule_from_instance('wordle', $wordle->id, $wordle->course, false, MUST_EXIST);

} else {
    if (!$cm = get_coursemodule_from_id('wordle', $id)) {
        print_error('invalidcoursemodule');
    }
    $wordle = $DB->get_record('wordle', array('id'=>$cm->instance), '*', MUST_EXIST);
}

$course = $DB->get_record('course', array('id'=>$cm->course), '*', MUST_EXIST);

require_course_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/wordle:view', $context);

// Completion and trigger events.
wordle_view($wordle, $course, $cm, $context);

$PAGE->set_url('/mod/wordle/view.php', array('id' => $cm->id));

$options = empty($wordle->displayoptions) ? [] : (array) unserialize_array($wordle->displayoptions);

if ($inpopup and $wordle->display == RESOURCELIB_DISPLAY_POPUP) {
    $PAGE->set_wordlelayout('popup');
    $PAGE->set_title($course->shortname.': '.$wordle->name);
    $PAGE->set_heading($course->fullname);
} else {
    $PAGE->set_title($course->shortname.': '.$wordle->name);
    $PAGE->set_heading($course->fullname);
    $PAGE->set_activity_record($wordle);
}
echo $OUTPUT->header();
if (!isset($options['printheading']) || !empty($options['printheading'])) {
    echo $OUTPUT->heading(format_string($wordle->name), 2);
}

// Display any activity information (eg completion requirements / dates).
$cminfo = cm_info::create($cm);
$completiondetails = \core_completion\cm_completion_details::get_instance($cminfo, $USER->id);
$activitydates = \core\activity_dates::get_dates_for_module($cminfo, $USER->id);
echo $OUTPUT->activity_information($cminfo, $completiondetails, $activitydates);

if (!empty($options['printintro'])) {
    if (trim(strip_tags($wordle->intro))) {
        echo $OUTPUT->box_start('mod_introbox', 'wordleintro');
        echo format_module_intro('wordle', $wordle, $cm->id);
        echo $OUTPUT->box_end();
    }
}

$content = file_rewrite_pluginfile_urls($wordle->content, 'pluginfile.php', $context->id, 'mod_wordle', 'content', $wordle->revision);
$formatoptions = new stdClass;
$formatoptions->noclean = true;
$formatoptions->overflowdiv = true;
$formatoptions->context = $context;
$content = format_text($content, $wordle->contentformat, $formatoptions);
echo $OUTPUT->box($content, "generalbox center clearfix");

if (!isset($options['printlastmodified']) || !empty($options['printlastmodified'])) {
    $strlastmodified = get_string("lastmodified");
    echo html_writer::div("$strlastmodified: " . userdate($wordle->timemodified), 'modified');
}

echo $OUTPUT->footer();
