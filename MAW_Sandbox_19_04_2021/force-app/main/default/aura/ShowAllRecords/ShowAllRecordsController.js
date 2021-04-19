({
    onChange: function (c, e, h) {
        if(c.find('select').get('v.value') == ""  ){
            c.set("v.showTable",false);
        }
        else{
            c.set("v.showTable",true);
            c.set('v.role', c.find('select').get('v.value'));
            h.onChange_h(c, e, h);
        }
    },
    handleSelect : function(c, e, h) {
        var selectedRows = e.getParam('selectedRows');
        var setId = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setId.push(selectedRows[i].Id);
        }
        c.set("v.stringOfIds", setId);
        c.set('v.changed', true);
    },
    save: function (c, e, h){
        h.onSave_h(c, e, h);
    }
})