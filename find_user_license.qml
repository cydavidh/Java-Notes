<qml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" bypassAccessControl="false" caseInsensitive="true" addTimeToDateFields="false" mainType="User" joinModel="false" xsi:noNamespaceSchemaLocation="qml.xsd">
<query>
<selectOrConstrain distinct="false" group="false">
<reportAttribute heading="Name" reportAttributeId="Name" userCanSelect="true" userCanConstrain="true" alwaysSelect="false" defaultValue="" constantValue="" isMacro="false">
<column alias="User" isExternal="false" type="java.lang.String" propertyName="name">name</column>
</reportAttribute>
<reportAttribute heading="Full Name" reportAttributeId="Full_Name" userCanSelect="true" userCanConstrain="true" alwaysSelect="false" defaultValue="" constantValue="" isMacro="false">
<column alias="User" isExternal="false" type="java.lang.String" propertyName="fullName">fullName</column>
</reportAttribute>
<reportAttribute heading="Group Name" reportAttributeId="Name_1" userCanSelect="true" userCanConstrain="true" alwaysSelect="false" defaultValue="" constantValue="" isMacro="false">
<column alias="Group (wt.org.WTGroup)" isExternal="false" type="java.lang.String" propertyName="name">name</column>
</reportAttribute>
<reportAttribute heading="Email" reportAttributeId="Email" userCanSelect="true" userCanConstrain="true" alwaysSelect="false" defaultValue="" constantValue="" isMacro="false">
<column alias="User" isExternal="false" type="java.lang.String" propertyName="eMail">eMail</column>
</reportAttribute>
</selectOrConstrain>
<from>
<table alias="User" isExternal="false" xposition="0px" yposition="40px">wt.org.WTUser</table>
<table alias="Group (wt.org.WTGroup)" isExternal="false" xposition="318px" yposition="39px">wt.org.WTGroup</table>
</from>
<linkJoin>
<join name="wt.org.MembershipLink">
<fromAliasTarget alias="Group (wt.org.WTGroup)"/>
<toAliasTarget alias="User"/>
</join>
</linkJoin>
</query>
</qml>