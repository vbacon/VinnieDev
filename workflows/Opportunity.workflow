<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_Declined_Owner_Notification</fullName>
        <description>Application Declined - Owner Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_Declined</template>
    </alerts>
    <fieldUpdates>
        <fullName>Opportunity_Changes_to_Rejected</fullName>
        <field>StageName</field>
        <literalValue>Rejected</literalValue>
        <name>Opportunity Changes to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppt_changes_to_Application_Approved</fullName>
        <field>StageName</field>
        <literalValue>Application Approved</literalValue>
        <name>Oppt. changes to Application Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Status_Date_Update</fullName>
        <field>Previous_Status_Date__c</field>
        <formula>PRIORVALUE(Current_Status_Date__c)</formula>
        <name>Previous Status Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update</fullName>
        <field>StageName</field>
        <literalValue>Rejected</literalValue>
        <name>Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity Previous Status Date</fullName>
        <actions>
            <name>Previous_Status_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule performs a field update everytime the &quot;Substate&quot; changes in order to populate the &quot;Previous Status Date&quot; field on opportunities</description>
        <formula>ISCHANGED( Substate__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
