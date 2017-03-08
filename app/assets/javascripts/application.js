// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require underscore
//= require gmaps/google


function checkAll(check_all) {
    // Pass in a named "Check All" checkbox that appears on the same form where All
    // checkboxes should be checked.

    // Loop through an array containing ALL inputs on the same form as check_all
    var inputs = check_all.form.getElementsByTagName('input');
    for (var i = 0; i < inputs.length; i++) {
        // Only work on checkboxes, and NOT on the "Check All" checkboxes
        if (inputs[i].type == 'checkbox') {
            if (check_all.checked == true) {
                inputs[i].checked = true;
            } else {
                inputs[i].checked = false;
            }
        }
    }
}

var selects = new Object();

function changeStatus(el) {
    var stat = el.getElementsByClassName('stat-btn')[0];
    var location_id = $(el).data("id");
    var location_col = $(el).data("col");

    if (stat.className.includes('fa-circle-thin')) {
        stat.className = "fa fa-check-circle fa-lg fa-orange stat-btn";
        if (selects[location_col]) {
            selects[location_col].push(location_id);
        } else {
            selects[location_col] = [location_id];
        }
        // console.log(selects);
    } else if (stat.className.includes('fa-check-circle')) {
        stat.className = "fa fa-circle-thin fa-lg fa-clear stat-btn";
        var index = selects[location_col].indexOf(location_id);
        selects[location_col].splice(index, 1);
        // console.log(selects);
    }
}

function mergeData() {
    console.log(selects);
    $.ajax({
        url: "/locations/update_status",
        data: {selects: selects}
    });
}

// function changeStatus(el) {
//     var stat = el.getElementsByClassName('stat-btn')[0];
//     var location_id = $(el).data("id");
//     var location_col = $(el).data("col");
//
//     if (stat.className.includes('fa-circle-thin')) {
//         stat.className = "fa fa-check-circle fa-lg fa-blue stat-btn";
//         $(stat).attr('data-original-title', 'Update Cell');
//     } else if (stat.className.includes('fa-check-circle')) {
//         stat.className = "fa fa-plus-circle fa-lg fa-green stat-btn";
//         $(stat).attr('data-original-title', 'Update Row');
//         update_status(location_id, location_col);
//     } else if (stat.className.includes('fa-plus-circle')) {
//         stat.className = "fa fa-minus-circle fa-lg fa-red stat-btn";
//         $(stat).attr('data-original-title', 'Remove Row');
//     } else if (stat.className.includes('fa-minus-circle')) {
//         stat.className = "fa fa-circle-thin fa-lg fa-clear stat-btn";
//         $(stat).attr('data-original-title', 'Reset');
//     }
// }
//
// function update_status(location_id, location_col) {
//     $.ajax({
//         url: "/locations/update_status",
//         data: {location_id: location_id, location_col: location_col}
//     });
// }


$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})


function changeHierarchy(el) {
    var hier = el.getElementsByClassName('hier-btn')[0];
    if (hier.className.includes('fa-dot-circle-o')) {
        hier.className = "fa fa-arrow-circle-up fa-lg fa-blue hier-btn";
        $(hier).attr('data-original-title', 'Parent');
    } else if (hier.className.includes('fa-arrow-circle-up')) {
        hier.className = "fa fa-arrow-circle-down fa-lg fa-green hier-btn";
        $(hier).attr('data-original-title', 'Child');
    } else if (hier.className.includes('fa-arrow-circle-down')) {
        hier.className = "fa fa-exclamation-circle fa-lg fa-red hier-btn";
        $(hier).attr('data-original-title', 'Alert');
    } else if (hier.className.includes('fa-exclamation-circle')) {
        hier.className = "fa fa-dot-circle-o fa-lg fa-clear hier-btn";
        $(hier).attr('data-original-title', 'None');
    }
}


( function($) {
    function iframeModalOpen(){
        $('.modalButton').on('click', function(e) {
            console.log(this);
            var src = $(this).attr('data-src');

            $("#myModal iframe").attr({
                'src': src
            });
        });

        $('#myModal').on('hidden.bs.modal', function(){
            $(this).find('iframe').html("");
            $(this).find('iframe').attr("src", "");
        });
    }

    $(document).ready(function(){
        iframeModalOpen();
    });
} ) ( jQuery );
