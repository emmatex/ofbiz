<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<#assign nowDate = Static["org.ofbiz.base.util.UtilDateTime"].nowDate()>

<h1>${uiLabelMap.WebtoolsEditCustomTimePeriods}</h1>
<br />
<#if security.hasPermission("PERIOD_MAINT", session)>
  <form method="post" action="<@ofbizUrl>EditCustomTimePeriod</@ofbizUrl>" name="setOrganizationPartyIdForm">
    <input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId?if_exists}">
    <span class="label">${uiLabelMap.WebtoolsShowOnlyPeriodsWithOrganization}</span>
    <input type="text" size="20" name="findOrganizationPartyId" value="${findOrganizationPartyId?if_exists}">
    <input type="submit" value='${uiLabelMap.CommonUpdate}'>
  </form>

  <br/>
  <div class="screenlet">
    <div class="screenlet-title-bar">
      <#if currentCustomTimePeriod?has_content>
        <ul>
          <li class="head3">${uiLabelMap.WebtoolsCurrentCustomTimePeriod}</li>
          <li><a href="<@ofbizUrl>EditCustomTimePeriod?findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>">${uiLabelMap.WebtoolsClearCurrent}</a></li>
        </ul>
        <br class="clear" />
      <#else>
        <h3>${uiLabelMap.WebtoolsCurrentCustomTimePeriod}</h3>
      </#if>
    </div>
    <#if currentCustomTimePeriod?has_content>
      <table class="basic-table" cellspacing="0">
        <tr class="header-row">
          <td>${uiLabelMap.CommonId}</td>
          <td>${uiLabelMap.WebtoolsParent}</td>
          <td>${uiLabelMap.WebtoolsOrgPartyId}</td>
          <td>${uiLabelMap.WebtoolsPeriodType}</td>
          <td>#</td>
          <td>${uiLabelMap.WebtoolsPeriodName}</td>
          <td>${uiLabelMap.CommonFromDate}</td>
          <td>${uiLabelMap.CommonThruDate}</td>
          <td>&nbsp;</td>
        </tr>
        <form method="post" action="<@ofbizUrl>updateCustomTimePeriod</@ofbizUrl>" name="updateCustomTimePeriodForm">
          <input type="hidden" name="findOrganizationPartyId" value="${findOrganizationPartyId?if_exists}">
          <input type="hidden" name="customTimePeriodId" value="${currentCustomTimePeriodId?if_exists}">
          <tr>
            <td>${currentCustomTimePeriod.customTimePeriodId}</td>
            <td>
              <select name="parentPeriodId">
                <option value=''>&nbsp;</option>
                <#list allCustomTimePeriods as allCustomTimePeriod>
                  <#assign allPeriodType = allCustomTimePeriod.getRelatedOneCache("PeriodType")>
                  <#assign isDefault = false>
                  <#if (currentCustomTimePeriod.parentPeriodId)?exists>
                    <#if currentCustomTimePeriod.customTimePeriodId = allCustomTimePeriod.customTimePeriodId>
                      <#assign isDefault = true>
                    </#if>
                  </#if>
                  <option value='${allCustomTimePeriod.customTimePeriodId}'<#if isDefault> selected="selected"</#if>>
                    ${allCustomTimePeriod.organizationPartyId}
                    <#if allPeriodType != null>${allPeriodType.description}:</#if>
                    ${allCustomTimePeriod.periodNum}
                    [${allCustomTimePeriod.customTimePeriodId}]
                  </option>
                </#list>
              </select>
              <#if (currentCustomTimePeriod.parentPeriodId)?exists>
                <a href='<@ofbizUrl>EditCustomTimePeriod?currentCustomTimePeriodId=${currentCustomTimePeriod.parentPeriodId}&findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>'>
	            ${uiLabelMap.WebtoolsSetAsCurrent}</a>
	          </#if>
            </td>
            <td><input type="text" size='12' name="currentCustomTimePeriod" value="${currentCustomTimePeriod.organizationPartyId?if_exists}"></td>
            <td>
              <select name="periodTypeId">
                <#list periodTypes as periodType>
                  <#assign isDefault = false>
                  <#if (currentCustomTimePeriod.periodTypeId)?exists>
                    <#if currentCustomTimePeriod.periodTypeId = periodType.periodTypeId>
                      <#assign isDefault = true>
                    </#if>
                  </#if>
                  <option value='${periodType.periodTypeId}'<#if isDefault> selected="selected"</#if>>
                    ${periodType.description} [${periodType.periodTypeId}]
                  </option>
                </#list>
              </select>
            </td>
            <td><input type="text" size='4' name="periodNum" value="${currentCustomTimePeriod.periodNum?if_exists}"></td>
            <td><input type="text" size='10' name="periodName" value="${currentCustomTimePeriod.periodName?if_exists}"></td>
            <td>
              <#assign hasntStarted = false>
              <#assign compareDate = currentCustomTimePeriod.getDate("fromDate")>
              <#if compareDate?has_content>
                <#if nowDate.before(compareDate)><#assign hasntStarted = true></#if>
              </#if>
              <input type="text" size='13' name="fromDate" value="${currentCustomTimePeriod.fromDate?string("yyyy-MM-dd")}"<#if hasntStarted> class="alert"</#if>>
            </td>
            <td>
              <#assign hasExpired = false>
              <#assign compareDate = currentCustomTimePeriod.getDate("thruDate")>
              <#if compareDate?has_content>
                <#if nowDate.after(compareDate)><#assign hasExpired = true></#if>
              </#if>
              <input type="text" size='13' name="thruDate" value="${currentCustomTimePeriod.thruDate?string("yyyy-MM-dd")}"<#if hasntStarted> class="alert"</#if>>
            </td>
            <td class="button-col">
              <input type="submit" value='${uiLabelMap.CommonUpdate}'>
              <a href='<@ofbizUrl>deleteCustomTimePeriod?customTimePeriodId=${currentCustomTimePeriod.customTimePeriodId}</@ofbizUrl>'>
              ${uiLabelMap.CommonDelete}</a>
            </td>
          </tr>
        </form>
      </table>
    <#else>
      <div class="screenlet-body">${uiLabelMap.WebtoolsMessage27}</div>
    </#if>
  </div>
  <br/>

  <div class="screenlet">
    <div class="screenlet-title-bar">
      <h3>${uiLabelMap.WebtoolsChildPeriods}</h3>
    </div>
    <#if customTimePeriods?has_content>
      <table class="basic-table" cellspacing="0">
        <tr class="header-row">
          <td>${uiLabelMap.CommonId}</td>
          <td>${uiLabelMap.WebtoolsParent}</td>
          <td>${uiLabelMap.WebtoolsOrgPartyId}</td>
          <td>${uiLabelMap.WebtoolsPeriodType}</td>
          <td>#</td>
          <td>${uiLabelMap.WebtoolsPeriodName}</td>
          <td>${uiLabelMap.CommonFromDate}</td>
          <td>${uiLabelMap.CommonThruDate}</td>
          <td>&nbsp;</td>
        </tr>
        <#assign line = 0>
        <#list customTimePeriods as customTimePeriod>
          <#assign line = line + 1>
          <#assign periodType = customTimePeriod.getRelatedOneCache("PeriodType")>
          <tr>
            <form method="post" action='<@ofbizUrl>updateCustomTimePeriod</@ofbizUrl>' name='lineForm${line}'>
              <input type="hidden" name="findOrganizationPartyId" value="${findOrganizationPartyId?if_exists}">
              <input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId?if_exists}">
              <input type="hidden" name="customTimePeriodId" value="${customTimePeriodId?if_exists}">
            <td>${customTimePeriod.customTimePeriodId}</td>
            <td>
              <select name="parentPeriodId">
                <option value=''>&nbsp;</option>
                <#list allCustomTimePeriods as allCustomTimePeriod>
                  <#assign allPeriodType = allCustomTimePeriod.getRelatedOneCache("PeriodType")>
                  <#assign isDefault = false>
                  <#if (currentCustomTimePeriod.parentPeriodId)?exists>
                    <#if currentCustomTimePeriod.customTimePeriodId = allCustomTimePeriod.customTimePeriodId>
                      <#assign isDefault = true>
                    </#if>
                  </#if>
                  <option value='${allCustomTimePeriod.customTimePeriodId}'<#if isDefault> selected="selected"</#if>>
                    ${allCustomTimePeriod.organizationPartyId}
                    <#if allPeriodType != null> ${allPeriodType.description}: </#if>
                    ${allCustomTimePeriod.periodNum}
                    [${allCustomTimePeriod.customTimePeriodId}]
                  </option>
                </#list>
              </select>
            </td>
            <td><input type="text" size='12' name="organizationPartyId" value="${customTimePeriod.organizationPartyId?if_exists}"></td>
            <td>
              <select name="periodTypeId">
                <#list periodTypes as periodType>
                  <#assign isDefault = false>
                  <#if (customTimePeriod.periodTypeId)?exists>
                    <#if customTimePeriod.periodTypeId = periodType.periodTypeId>
                     <#assign isDefault = true>
                    </#if>
                  </#if>
                  <option value='${periodType.periodTypeId}'<#if isDefault> selected="selected"</#if>>${periodType.description} [${periodType.periodTypeId}]</option>
                </#list>
              </select>
            </td>
            <td><input type="text" size='4' name="periodNum" value="${customTimePeriod.periodNum?if_exists}"></td>
            <td><input type="text" size='10' name="periodName" value="${customTimePeriod.periodName?if_exists}"></td>
            <td>
              <#assign hasntStarted = false>
              <#assign compareDate = customTimePeriod.getDate("fromDate")>
              <#if compareDate?has_content>
                <#if nowDate.before(compareDate)><#assign hasntStarted = true></#if>
              </#if>
              <input type="text" size='13' name="fromDate" value="${customTimePeriod.fromDate?if_exists}"<#if hasntStarted> class="alert"</#if>>
            </td>
            <td>
              <#assign hasExpired = false>
              <#assign compareDate = customTimePeriod.getDate("thruDate")>
              <#if compareDate?has_content>
                <#if nowDate.after(compareDate)><#assign hasExpired = true></#if>
              </#if>
              <input type="text" size='13' name="thruDate" value="${customTimePeriod.thruDate?if_exists}"<#if hasExpired> class="alert"</#if>>
             </td>
             <td class="button-col">
              <input type="submit" value='${uiLabelMap.CommonUpdate}'>
              <a href='<@ofbizUrl>deleteCustomTimePeriod?customTimePeriodId=${customTimePeriod.customTimePeriodId?if_exists}&currentCustomTimePeriodId=${currentCustomTimePeriodId?if_exists}&findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>'>
              ${uiLabelMap.CommonDelete}</a>
              <a href='<@ofbizUrl>EditCustomTimePeriod?currentCustomTimePeriodId=${customTimePeriod.customTimePeriodId?if_exists}&findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>'>
              ${uiLabelMap.WebtoolsSetAsCurrent}</a>
            </td>
            </form>
          </tr>
        </#list>
      </table>
    <#else>
      <div class="screenlet-body">${uiLabelMap.WebtoolsMessage28}</div>
    </#if>
  </div>
  <br/>

  <div class="screenlet">
    <div class="screenlet-title-bar">
      <h3>${uiLabelMap.WebtoolsAddCustomTimePeriod}</h3>
    </div>
    <div class="screenlet-body">
      <form method="POST" action="<@ofbizUrl>createCustomTimePeriod</@ofbizUrl>" name="createCustomTimePeriodForm">
        <input type="hidden" name="findOrganizationPartyId" value="${findOrganizationPartyId?if_exists}">
        <input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId?if_exists}">
        <input type="hidden" name="useValues" value="true">
        <div>
          <span class="label">${uiLabelMap.WebtoolsParent}</span>
          <select name="parentPeriodId">
            <option value=''>&nbsp;</option>
            <#list allCustomTimePeriods as allCustomTimePeriod>
      		  <#assign allPeriodType = allCustomTimePeriod.getRelatedOneCache("PeriodType")>
              <#assign isDefault = false>
              <#if currentCustomTimePeriod?exists>
                <#if currentCustomTimePeriod.customTimePeriodId = allCustomTimePeriod.customTimePeriodId>
                  <#assign isDefault = true>
                </#if>
              </#if>
              <option value="${allCustomTimePeriod.customTimePeriodId}"<#if isDefault> selected="selected"</#if>>
                ${allCustomTimePeriod.organizationPartyId}
                <#if (allCustomTimePeriod.parentPeriodId)?exists>Par:${allCustomTimePeriod.parentPeriodId}</#if>
                <#if allPeriodType != null> ${allPeriodType.description}:</#if>
                ${allCustomTimePeriod.periodNum}
                [${allCustomTimePeriod.customTimePeriodId}]
              </option>
            </#list>
          </select>
        </div>
        <div>
          <span class="label">${uiLabelMap.WebtoolsOrgPartyId}</span>
          <input type="text" size='20' name='organizationPartyId'>
          <span class="label">${uiLabelMap.WebtoolsPeriodType}</span>
          <select name="periodTypeId">
            <#list periodTypes as periodType>
              <#assign isDefault = false>
              <#if newPeriodTypeId?exists>
                <#if newPeriodTypeId = periodType.periodTypeId>
                  <#assign isDefault = true>
                </#if>
              </#if>
              <option value="${periodType.periodTypeId}" <#if isDefault>selected="selected"</#if>>${periodType.description} [${periodType.periodTypeId}]</option>
            </#list>
          </select>
          <span class="label">${uiLabelMap.WebtoolsPeriodNumber}</span>
          <input type="text" size='4' name='periodNum'>
          <span class="label">${uiLabelMap.WebtoolsPeriodName}</span>
          <input type="text" size='10' name='periodName'>
        </div>
        <div>
          <span class="label">${uiLabelMap.CommonFromDate}</span>
          <input type="text" size='14' name='fromDate'>
          <span class="label">${uiLabelMap.CommonThruDate}</span>
          <input type="text" size='14' name='thruDate'>
          <input type="submit" value="${uiLabelMap.CommonAdd}">
        </div>
      </form>
    </div>
  </div>
<#else>
  <h3>${uiLabelMap.WebtoolsPermissionPeriod}.</h3>
</#if>
