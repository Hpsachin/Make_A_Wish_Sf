({
    doinit: function(c, e, h) {
        h.doinit_helper(c, e, h);
        h.attachmentList_helper(c, e, h);
        var valueFrom = c.find("from").get("v.value");
        c.set('v.fromValue',valueFrom);
        c.set('v.roleValue','');
    },
    handleChange: function (c, e, h) {
        
        var m =c.get("v.roleValue");
        if(m != ""){
            h.handleChange_helper(c, e, h)
            c.set('v.roleValue',m);
        }
        else{
            c.set('v.roleValue','');
            c.set('v.subject','');
            c.set('v.body','');
            
        }
    },
    
    SendEmail: function(c, e, h){
        h.sendEmail_Helper(c, e, h);
    },
    isOpenModel : function(c, e, h){
        h.attachmentList_helper(c, e, h);
        c.set('v.isOpenModel', true);
    },
    closeModel: function(c, e, h) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        c.set("v.isOpenModel", false);
        c.set('v.checkRecordList',[]);
        c.set("v.addLabel",'Add');
        c.set("v.isDisable", true);
        c.set("v.addNumber",0);
    },
    handleUploadFinished: function (c, e, h) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = e.getParam("files");
        h.getUploadedList_helper(c, e, h);
    },
    Showhide : function(c, e, h) {
        var isChacked = e.getSource().get('v.checked');
        if(isChacked){
            h.showHideCheckRecord_helper1(c, e, h) 
            
        }else{
            h.showHideCheckRecord_helper2(c, e, h)
        }
    },
    searchKeyChangeAttachment: function(c, e, h){
        h.searchKeyChangeAttachment_helper(c, e, h)
    },
    addAttachmentFile: function(c, e, h){
        h.addAttachmentFile_helper(c, e, h)
    },
    previewFile :function(c, e, h){
        var Id = e.target.id;
        $A.get('e.lightning:openFiles').fire({
            recordIds: [Id]
        });
    },
    removeAttachment: function(c, e, h){
        h.removeAttachment_helper(c, e, h)    
    },
    
    clickCheckBox: function(c, e, h){
        var id = e.target.name
        var checkbox = c.find(id)
        },
    hideError: function(c, e, h){
        c.set('v.showErrorflagForInputEmail',false);
        c.set("v.flag1",false);
        c.set("v.flag2",false);
        c.set("v.flag3",false);
    },
    onChangeEmail: function(c, e, h){
        var EmailValue = c.get('v.newEmail');
        var roleValue = c.get('v.roleValue');
        var Body = c.get('v.body');
        if(roleValue === 'Social Worker'){
            if(!$A.util.isEmpty(EmailValue) && EmailValue.length == 1){
                if(!$A.util.isEmpty(Body) && Body.includes("{!Case.SW_Email__c}")){
                    Body = Body.replace("{!Case.SW_Email__c}",EmailValue);
                }
                else if(!$A.util.isEmpty(Body)){
                    Body = Body.replace("Username - "+c.get('v.oldEmailValue'), "Username - "+EmailValue);
                }
            }
            else if(!$A.util.isEmpty(Body)){
                Body = Body.replace("Username - "+c.get('v.oldEmailValue'), "Username - "+EmailValue);
            }
            c.set("v.oldEmailValue",EmailValue);
            c.set("v.body",Body);
        }
        else if(roleValue === 'Medical Specialist'){
            if(!$A.util.isEmpty(EmailValue) && EmailValue.length == 1){
                if(!$A.util.isEmpty(Body) && Body.includes("{!Case.MP_Email__c}")){
                    Body = Body.replace("{!Case.MP_Email__c}",EmailValue);
                }
                else if(!$A.util.isEmpty(Body)){
                    Body = Body.replace("Username - "+c.get('v.oldEmailValue'), "Username - "+EmailValue);
                }
            }
            else if(!$A.util.isEmpty(Body)){
                Body = Body.replace("Username - "+c.get('v.oldEmailValue'), "Username - "+EmailValue);
            }
            c.set("v.oldEmailValue",EmailValue);
            c.set("v.body",Body);
        }
        
    }
});