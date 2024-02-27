global virtual class TriggerHandler {

    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;
    @TestVisible
    private static String topHandlerName;
    private static Map<String, Boolean> runOnce;

    @TestVisible
    private TriggerContext context;

    @TestVisible
    private Boolean isTriggerExecuting;

    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
        runOnce = new Map<String, Boolean>();
    }

    global static Boolean checkRunOnce(String handlerAndMethodName) {

        if (null==runOnce.get(handlerAndMethodName) ) {
            runOnce.put(handlerAndMethodName, false);
            return true;
        }

        return false;
    }

    global TriggerHandler() {

        this.setTriggerContext();
        if (null==TriggerHandler.topHandlerName) {
            TriggerHandler.topHandlerName=getHandlerName();
        }
    }

    global void run() {

        if (!validateRun()) return;

        addToLoopCount();

        if (this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        }
        else if (this.context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        }
        else if (this.context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        }
        else if (this.context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        }
        else if (this.context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        }
        else if (this.context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        }
        else if (this.context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
    }

    global void setMaxLoopCount(Integer max) {

        String handlerName = getHandlerName();

        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        }
        else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }

    global void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    global Boolean canRunOnce(String methodName) {
        return checkRunOnce(getHandlerName()+'.'+methodName);
    }

    global static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }

    global static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    global static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    global static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }

    global static String getTopHandlerName() {
        return topHandlerName;
    }

    global static void resetRun() {
        runOnce = new Map<String, Boolean>();
    }

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {

        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        }
        else {
            this.isTriggerExecuting = true;
        }

        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
                (ctx != null && ctx == 'before insert')) {
            this.context = TriggerContext.BEFORE_INSERT;
        }
        else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
                (ctx != null && ctx == 'before update')){
            this.context = TriggerContext.BEFORE_UPDATE;
        }
        else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
                (ctx != null && ctx == 'before delete')) {
            this.context = TriggerContext.BEFORE_DELETE;
        }
        else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
                (ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        }
        else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
                (ctx != null && ctx == 'after update')) {
            this.context = TriggerContext.AFTER_UPDATE;
        }
        else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
                (ctx != null && ctx == 'after delete')) {
            this.context = TriggerContext.AFTER_DELETE;
        }
        else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
                (ctx != null && ctx == 'after undelete')) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }

    @TestVisible
    private void addToLoopCount() {

        String handlerName = getHandlerName();

        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {

            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();

            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    @TestVisible
    private Boolean validateRun() {

        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }

        if (TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
            System.debug('bypassed triggerhandler: ' + getHandlerName());
            return false;
        }

        return true;
    }

    @TestVisible
    global String getHandlerName() {

        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    @TestVisible
    global protected virtual void beforeInsert(){}

    @TestVisible
    global protected virtual void beforeUpdate(){}

    @TestVisible
    global protected virtual void beforeDelete(){}

    @TestVisible
    global protected virtual void afterInsert(){}

    @TestVisible
    global protected virtual void afterUpdate(){}

    @TestVisible
    global protected virtual void afterDelete(){}

    @TestVisible
    global protected virtual void afterUndelete(){}

    @TestVisible
    global class LoopCount {

        private Integer max;
        private Integer count;

        global LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        global LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }

        global Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        global Boolean exceeded() {

            if (this.max < 0) {
                return false;
            }

            if (this.count > this.max) {
                return true;
            }

            return false;
        }

        global Integer getMax() {
            return this.max;
        }

        global Integer getCount() {
            return this.count;
        }

        global void setMax(Integer max) {
            this.max = max;
        }
    }

    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }

    global class TriggerHandlerException extends Exception {}
}