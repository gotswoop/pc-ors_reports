    function addGroup() {
        alert("Modifying routing groups:\n\nThese groups are part of your data dictionary. Edit the options for the 'routing' field to update this list.");
        // todo: GO TO PROJECT SETUP
    }
    function showButton(elem) {
        alert($(elem).parent().next().children()[0].show());
    }
    function savePeople() {
        var peoples = $('input.peoples');
        var newGroups = {};
        for(var p = 0; p < peoples.length; p++) {
            var group = $(peoples[p]).parent().prev().text();
            newGroups[group] = peoples[p].value;
        }
        groupsJson = JSON.stringify(newGroups);
        var form = document.getElementById("groupsForm");
        form.newGroups.value = groupsJson;
        form.submit();
        //var newHref = 'orspeople.php?pid=<?php echo $PROJECTID;?>&newGroups='+groupsJson;
        //window.location = newHref;
    }

