({
    doinit_helper : function(c,e,h) {
        try{
            var action = c.get("c.getUserEmailIdAndName");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    c.set("v.defaultUser",response);
                    var newList = [{ value: "Email", label: response.Name +'<'+response.Email+'>'}];
                    c.set("v.user", newList);
                }
            });
            // Send action off to be executed
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
    },
    attachmentList_helper : function(c, e, h){
        try{
            var action = c.get("c.getAttachmentList");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    c.set("v.attchmentList",response.getReturnValue());   
                }
            });
            // Send action off to be executed
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }    
    },
    handleChange_helper : function(c, e, h){
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = e.getParam("value");
        console.log('selectedOptionValue===>'+selectedOptionValue);
        var action=c.get("c.getTemplate");
        action.setParams({
            role: selectedOptionValue
        })
        action.setCallback(this,function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                if(!$A.util.isEmpty(result)){
                    if(!$A.util.isEmpty(result.emailTemplateData)){
                        if(!$A.util.isEmpty(result.emailTemplateData.Subject))
                            c.set("v.subject", result.emailTemplateData.Subject);
                        
                        if(!$A.util.isEmpty(result.emailTemplateData.Body)){
                            if(selectedOptionValue === 'Social Worker'){
                                if(!$A.util.isEmpty(result.emailTemplateData.Body) && !$A.util.isEmpty(c.get('v.newEmail'))){
                                    result.emailTemplateData.Body = result.emailTemplateData.Body.replaceAll('{!Case.SW_First_Name__c}','___________________')
                                    result.emailTemplateData.Body = result.emailTemplateData.Body.replace("{!Case.SW_Email__c}",c.get('v.newEmail'));
                                }
                                else{
                                    result.emailTemplateData.Body = result.emailTemplateData.Body.replaceAll('{!Case.SW_First_Name__c}','___________________');
                                }
                                
                                c.set("v.body", result.emailTemplateData.Body);
                            }else if(selectedOptionValue === 'Medical Specialist'){
                                
                                if(!$A.util.isEmpty(result.emailTemplateData.Body) && !$A.util.isEmpty(c.get('v.newEmail'))){
                                    result.emailTemplateData.Body = result.emailTemplateData.Body.replaceAll('{!Case.MP_First_Name__c}','___________________')
                                    result.emailTemplateData.Body = result.emailTemplateData.Body.replace("{!Case.MP_Email__c}",c.get('v.newEmail'));
                                }
                                else{
                                    result.emailTemplateData.Body = result.emailTemplateData.Body.replaceAll('{!Case.MP_First_Name__c}','___________________');
                                }
                                
                                c.set("v.body", result.emailTemplateData.Body);
                            }
                        }
                    }
                    
                    if(!$A.util.isEmpty(result.emailSet)){
                        c.set('v.RoleEmailSet',result.emailSet);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
   
    searchKeyChangeAttachment_helper : function(c, e, h){
        var searchKey = e.getSource().get("v.value");
        if($A.util.isEmpty(searchKey)){
            h.attachmentList_helper(c, e, h);
        } else{
            var action = c.get("c.findByTitle");
            action.setParams({
                "searchKey": searchKey
            });
            action.setCallback(this, function(response) {
                c.set("v.attchmentList", response.getReturnValue());
            });
            $A.enqueueAction(action);  
        }
    },
    
    getUploadedList_helper: function(c, e, h){
        var uploadedFiles = e.getParam("files");
        var selectedUpLoadedFiles = c.get('v.uploadedList');
        var s = uploadedFiles[0].name; 
        var indexOfDot = s.indexOf(".");
        var res = s.substr(indexOfDot+1);
        var obj = {};
        obj.Title = uploadedFiles[0].name;
        obj.Id = uploadedFiles[0].documentId;
        obj.FileExtension = res;
        selectedUpLoadedFiles.push(obj);
        c.set('v.uploadedList',selectedUpLoadedFiles);
        c.set("v.isOpenModel", false);
    },
    sendEmail_Helper :function(c, e, h){
        var emailRoleSet = c.get('v.RoleEmailSet');
        var getUserEmail = c.get('v.fromValue');
        var getEmailTo = c.get('v.newEmail');
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var getSubject = c.find('subjectfield').get('v.value');
        var getBody = c.find('bodyfield').get('v.value');
        var getBodyInHtml = '';
        if(getBody != undefined){
            getBodyInHtml = getBody;
            getBody= (getBody.replace(/<[/a-zAZ0-9]*>/g,"")).trim();
                                      }
                                      var uploadAttachments =c.get('v.uploadedList');
                      var fileId = [];    
                      for(var i=0; i < uploadAttachments.length; i++){
                fileId.push(uploadAttachments[i].Id);  
            }    
            if($A.util.isEmpty(c.get('v.roleValue'))){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Review the errors on this page',
                    message:'Select the Role.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            if($A.util.isEmpty(getEmailTo) ||  getEmailTo == undefined || getEmailTo == ''){
                var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Review the errors on this page',
                            message:'Add a recipient to send an email.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        return;
            }else if(!getEmailTo.match(regExpEmailformat)){
                c.set("v.showErrorflagForInputEmail",true);
                c.set("v.flag1",true);
                c.set("v.showErrorflagForInputEmail",true);
                c.set("v.ErrorMsgForInputEmail",'Invalid Email Id');
                return;
            }else {
                c.set("v.showErrorflagForInputEmail",false);
                c.set("v.flag1",false);
                c.set("v.ErrorMsgForInputEmail",null);                
            }
            if($A.util.isEmpty(getSubject) || getSubject.trim() == ""){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Review the errors on this page',
                    message:'fill the subject.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            if($A.util.isEmpty(getBody) || getBody == undefined){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Review the errors on this page',
                    message:'fill the body.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            if(!$A.util.isEmpty(emailRoleSet) && emailRoleSet.includes(getEmailTo)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Review the errors on this page',
                    message: c.get('v.roleValue')+' with this email id already exists.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            else{
                h.sendEmail_Helper12(c, e, h, getEmailTo, getSubject, getBodyInHtml, fileId );
            }
           
            c.set("v.pillsForinput", []);
            c.set("v.CCpillsForinput", []);
            c.set("v.BCCpillsForinput", []);
            c.set('v.roleValue','');
            c.find('subjectfield').set('v.value',"");
            c.find('bodyfield').set('v.value',"");
            c.set("v.uploadedList", []);
        },
            
            sendEmail_Helper12 : function(c, e, h, emailTo, getSubject, getBody, fileId ){
                getBody = getBody.replaceAll('<p><br></p>','');
                var action = c.get("c.sendMailMethod");
                action.setParams({
                    'mailTo': emailTo,
                    'mSubject': getSubject,
                    'mbody': getBody,
                    'attachmentFileId': fileId
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        h.successToast_helper(c, e, h);
                        c.set('v.roleValue','');
                        c.set('v.newEmail','');
                    }
                });
                
                $A.enqueueAction(action);
            },
                successToast_helper : function(c, e, h) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Email Sent',
                        message: 'Invite for Signup sent successfully.',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                },
                    showErrorMsg : function(c, e, h, msg){
                        c.set("v.toastMessage", msg);
                        c.set("v.showError", true);
                        
                        window.setTimeout(
                            $A.getCallback(function() {
                                c.set("v.showError", false);
                                c.set("v.toastMessage", "");
                            }), 3000);
                    },
                        
                        showHideCheckRecord_helper1: function(c, e, h){
                            var getSelectedRecord = e.getSource().get('v.value').split(",");
                            var selectedRecordList = c.get('v.checkRecordList');
                            var count = 0;
                            if(selectedRecordList.length < 10){
                                var selectedRecords = {
                                    'Id': getSelectedRecord[0],
                                    'Title': getSelectedRecord[1],
                                    'ContentModifiedDate':getSelectedRecord[2],
                                    'ContentSize':getSelectedRecord[3],
                                    'FileExtension':getSelectedRecord[4]
                                } 
                                var duplicateFile = false;
                                if(selectedRecordList.length == 0){
                                    selectedRecordList.push(selectedRecords);
                                }
                                else{
                                    for(var i=0;i<selectedRecordList.length;i++){
                                        if(selectedRecords.Id == selectedRecordList[i].Id){
                                            duplicateFile = true;
                                        }
                                    }
                                    if(!duplicateFile){
                                        selectedRecordList.push(selectedRecords);
                                        c.set('v.checkRecordList',selectedRecordList);
                                    }   
                                }
                                
                                count = selectedRecordList.length;
                                c.set('v.labelCount',count);
                                var s = 'Add'+'(' +count+ ')';
                                var a = count;
                                c.set('v.addNumber',a);
                                c.set('v.addLabel',s);
                                
                                c.set('v.checkRecordList',selectedRecordList);
                                var getSelectedRecor12 = c.get('v.checkRecordList').length;
                                
                                if(getSelectedRecor12 > 0){
                                    c.set("v.isDisable", false);
                                }
                            }else{
                                e.getSource().set('v.checked',false);
                            }
                        },
                            showHideCheckRecord_helper2: function(c, e, h){
                                var getUnselectedRecord = e.getSource().get('v.value').split(",");
                                var getSelectedRecord = c.get('v.checkRecordList')
                                for (var i = 0; i < getSelectedRecord.length; i++) {
                                    if (getUnselectedRecord[0] == getSelectedRecord[i].Id) {
                                        getSelectedRecord.splice(i, 1);
                                    }
                                }
                                
                                var length = getSelectedRecord.length;
                                if(length>=1){
                                    var s = 'Add'+'(' +length+ ')';
                                    var a = length;
                                    c.set('v.addNumber',a);
                                    c.set('v.addLabel',s);
                                }
                                else{
                                    c.set('v.addLabel','Add'); 
                                    c.set('v.addNumber',0);
                                }
                                var getSelectedRecord = c.get('v.checkRecordList').length;
                                
                                if(getSelectedRecord == 0){
                                    c.set("v.isDisable", true);
                                }
                            },
                                
                                addAttachmentFile_helper: function(c, e, h){
                                    var uploadedFileList = c.get('v.uploadedList');
                                    var checkedFileList = c.get('v.checkRecordList');
                                    for(var i=0;i<checkedFileList.length;i++){
                                        uploadedFileList.push(checkedFileList[i]);
                                    }
                                    
                                    c.set('v.uploadedList',uploadedFileList);
                                    c.set('v.checkRecordList',[]);
                                    c.set("v.addLabel",'Add');
                                    c.set("v.isOpenModel", false);
                                    c.set("v.isDisable", true);
                                },
                                    removeAttachment_helper: function(c, e, h){
                                        var attachmentId = e.getSource().get('v.value');
                                        var attachments = c.get('v.uploadedList');
                                        for (var i = 0; i < attachments.length; i++) {
                                            if (attachmentId == attachments[i].Id) {
                                                attachments.splice(i, 1);
                                            }
                                        }
                                        c.set('v.uploadedList', attachments);    
                                    },
                                        searchAllEmail : function(component, event, helper,InputCheck) {
                                            try {
                                                var EmailList  = component.get("v.AllEmailList");
                                                var EmailListArray = [];
                                                for(var each of EmailList)
                                                {
                                                    if(each.Objname.includes(InputCheck)){
                                                        
                                                        EmailListArray.push(each);
                                                    }
                                                    else{
                                                        component.set("v.newEmail",InputCheck);
                                                        component.set("v.showEmailflag",false);
                                                        
                                                    }
                                                    
                                                }
                                                if(!$A.util.isUndefinedOrNull(EmailListArray) && !$A.util.isEmpty(EmailListArray)){
                                                    component.set("v.Searchlist",EmailListArray);
                                                    component.set("v.showEmailflag",true);
                                                }
                                                
                                            }
                                            catch (error) {
                                                console.error(error);
                                            }
                                        },
    })