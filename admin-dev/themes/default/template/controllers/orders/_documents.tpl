{*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
<table class="table" id="documents_table">
	<thead>
		<tr>
			<th>
				<span class="title_box ">{l s='Date'}</span>
			</th>
			<th>
				<span class="title_box ">{l s='Document'}</span>
			</th>
			<th>
				<span class="title_box ">{l s='Number'}</span>
			</th>
			<th>
				<span class="title_box ">{l s='Amount'}</span>
			</th>
			{if Configuration::get('PS_EDS') && Configuration::get('PS_EDS_EMAIL_PDF')}
			<th></th>
			{/if}
			<th></th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$order->getDocuments() item=document}

			{if get_class($document) eq 'OrderInvoice'}
				{if isset($document->is_delivery)}
				<tr id="delivery_{$document->id}">
				{elseif isset($document->is_package)}
				<tr id="package">
				{else}
				<tr id="invoice_{$document->id}">
				{/if}
			{elseif get_class($document) eq 'OrderSlip'}
				<tr id="orderslip_{$document->id}">
			{elseif get_class($document) eq 'OrderDelivery'}
				<tr id="delivery_{$document->id}">
			{/if}

					<td>
					{if get_class($document) eq 'OrderInvoice' && isset($document->is_package)}
						--
					{else}
						{dateFormat date=$document->date_add}
					{/if}
					</td>
					<td>
						{if get_class($document) eq 'OrderInvoice'}
							{if isset($document->is_delivery)}
								{l s='Delivery slip'}
							{elseif isset($document->is_package)}
								{l s='Packing slip'}
							{else}
								{l s='Invoice'}
								{if Configuration::get('PS_EDS') && Configuration::get('PS_EDS_INVOICE_DELIVERED') && $document->delivery_number > 0 } {l s='for Delivery Slip'} {$document->delivery_number}{/if}
							{/if}
						{elseif get_class($document) eq 'OrderSlip'}
							{l s='Credit Slip'}
						{elseif get_class($document) eq 'OrderDelivery'}
							{l s='Delivery Slip'} {$document->delivery_number}
						{/if}
					</td>
					<td>
						{if get_class($document) eq 'OrderInvoice'}

							{if isset($document->is_delivery)}
							<a target="_blank" title="{l s='See the document'}" href="{$link->getAdminLink('AdminPdf')|escape:'html':'UTF-8'}&submitAction=generateDeliverySlipPDF&id_order_invoice={$document->id}">
							{elseif isset($document->is_package)}
							<a target="_blank" title="{l s='See the document'}" href="{$link->getAdminLink('AdminPdf')|escape:'html':'UTF-8'}&submitAction=generatePackageSlipPDF&id_order_invoice={$document->id}">
						   	{else}
							<a target="_blank" title="{l s='See the document'}" href="{$link->getAdminLink('AdminPdf')|escape:'html':'UTF-8'}&submitAction=generateInvoicePDF&id_order_invoice={$document->id}">
						   {/if}

						{elseif get_class($document) eq 'OrderSlip'}
							<a target="_blank" title="{l s='See the document'}" href="{$link->getAdminLink('AdminPdf')|escape:'html':'UTF-8'}&submitAction=generateOrderSlipPDF&id_order_slip={$document->id}">
						{elseif get_class($document) eq 'OrderDelivery'}
							<a target="_blank" title="{l s='See the document'}" href="{$link->getAdminLink('AdminPdf')|escape:'html':'UTF-8'}&submitAction=generateDeliverySlipPDF&id_order_invoice={$document->id_order_invoice}">
						{/if}

						{if get_class($document) eq 'OrderInvoice'}
						
							{if isset($document->is_delivery)}
								#{Configuration::get('PS_DELIVERY_PREFIX', $current_id_lang, null, $order->id_shop)}{'%06d'|sprintf:$document->delivery_number}
							{elseif isset($document->is_package)}
								#{l s='PACKSLIP'}
							{else}
								{$document->getInvoiceNumberFormatted($current_id_lang, $order->id_shop)}
							{/if}

						{elseif get_class($document) eq 'OrderSlip'}

							#{Configuration::get('PS_CREDIT_SLIP_PREFIX', $current_id_lang)}{'%06d'|sprintf:$document->id}

						{elseif get_class($document) eq 'OrderDelivery'}

							#{Configuration::get('PS_DELIVERY_PREFIX', $current_id_lang, null, $order->id_shop)}{'%06d'|sprintf:$document->id_order_invoice}-{$document->delivery_number}

						{/if}
						</a>
					</td>
					<td>
					{if get_class($document) eq 'OrderInvoice'}
						{if isset($document->is_delivery)}
							--
						{elseif isset($document->is_package)}
							--
						{else}
							{displayPrice price=$document->total_paid_tax_incl currency=$currency->id}&nbsp;
							{if $document->getTotalPaid()}
								<span>
								{if $document->getRestPaid() > 0}
									({displayPrice price=$document->getRestPaid() currency=$currency->id} {l s='not paid'})
								{else if $document->getRestPaid() < 0}
									({displayPrice price=-$document->getRestPaid() currency=$currency->id} {l s='overpaid'})
								{/if}
								</span>
							{/if}
						{/if}
					{elseif get_class($document) eq 'OrderSlip'}
						{displayPrice price=$document->amount currency=$currency->id}
					{elseif get_class($document) eq 'OrderDelivery'}
						--
					{/if}
					</td>
					{if Configuration::get('PS_EDS') && Configuration::get('PS_EDS_EMAIL_PDF')}
					<td class="text-right document_action">
						<form method="post" action="{$currentIndex}&vieworder&id_order={$order->id}&token={$smarty.get.token|escape:'htmlall':'UTF-8'}">
							<input type="hidden" name="id_order_invoice" value="{$document->id}" />
							{if get_class($document) eq 'OrderInvoice'}
								{if !isset($document->is_delivery) && !isset($document->is_package)}
								<input type="image" src="../img/admin/bg_form_email.png" name="emailInvoice" value="1" title="E-mail Invoice as PDF" />
								{/if}
							{elseif get_class($document) eq 'OrderDelivery'}
								<input type="image" src="../img/admin/bg_form_email.png" name="emailDelivery" value="1" title="E-mail Delivery Slip as PDF" />
							{/if}
						</form>
					</td>
					{/if}
					<td class="text-right document_action">
					{if get_class($document) eq 'OrderInvoice'}
						{if !isset($document->is_delivery) && !isset($document->is_package)}

							{if $document->getRestPaid()}
								<a href="#" class="js-set-payment btn btn-default" data-amount="{$document->getRestPaid()}" data-id-invoice="{$document->id}" title="{l s='Set payment form'}">
									<i class="icon-money"></i>
									{l s='Enter Payment'}
								</a>
							{/if}

							<a href="#" class="btn btn-default" onclick="$('#invoiceNote{$document->id}').show(); return false;" title="{if $document->note eq ''}{l s='Add note'}{else}{l s='Edit note'}{/if}">
								{if $document->note eq ''}
									<i class="icon-plus-sign-alt"></i>
									{l s='Add note'}
								{else}
									<i class="icon-pencil"></i>
									{l s='Edit note'}
								{/if}
							</a>

						{/if}
					{/if}
					</td>
				</tr>
			{if get_class($document) eq 'OrderInvoice'}
				{if !isset($document->is_delivery) && !isset($document->is_package)}
				<tr id="invoiceNote{$document->id}" style="display:none">
					<td colspan="5">
						<form action="{$current_index}&viewOrder&id_order={$order->id}{if isset($smarty.get.token)}&token={$smarty.get.token|escape:'html':'UTF-8'}{/if}" method="post">
							<p>
								<label for="editNote{$document->id}" class="t">{l s='Note'}</label>
								<input type="hidden" name="id_order_invoice" value="{$document->id}" />
								<textarea name="note" id="editNote{$document->id}" class="edit-note textarea-autosize">{$document->note|escape:'html':'UTF-8'}</textarea>
							</p>
							<p>
								<button type="submit" name="submitEditNote" class="btn btn-default"> 
									<i class="icon-save"></i>
									{l s='Save'}
								</button>
								<a class="btn btn-default" href="#" id="cancelNote" onclick="$('#invoiceNote{$document->id}').hide();return false;">
									<i class="icon-remove"></i>
									{l s='Cancel'}
								</a>
							</p>
						</form>
					</td>
				</tr>
				{/if}
			{/if}
		{foreachelse}
			<tr>
				<td colspan="5" class="text-center">
					<i class="icon-warning-sign"></i> {l s='No documents are available'}
					{if isset($invoice_management_active) && $invoice_management_active}
						<a class="btn btn-link" href="{$current_index}&viewOrder&submitGenerateInvoice&id_order={$order->id}{if isset($smarty.get.token)}&token={$smarty.get.token|escape:'html':'UTF-8'}{/if}">
							<i class="icon-repeat"></i>
							{l s='Generate invoice'}
						</a>
					{/if}
				</td>
			</tr>
		{/foreach}
	</tbody>
</table>