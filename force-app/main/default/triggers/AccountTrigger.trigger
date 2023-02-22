trigger AccountTrigger on Account (Before update) {
        AccountTriggerHandler.updateDescription(Trigger.New);
    
}