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

{* Assign product price *}
{if ($order->getTaxCalculationMethod() == $smarty.const.PS_TAX_EXC)}
	{assign var=product_price value=($product['unit_price_tax_excl'] + $product['ecotax'])}
{else}
	{assign var=product_price value=$product['unit_price_tax_incl']}
{/if}

{if ($product['product_quantity'] > $product['customizationQuantityTotal'])}
<tr class="product-line-row" {if isset($product.image) && $product.image->id && isset($product.image_size)} height="{$product['image_size'][1] + 7}"{/if}>
	<td>{if isset($product.image) && $product.image->id}{$product.image_tag}{/if}</td>
	<td><a href="index.php?controller=adminproducts&id_product={$product['product_id']}&updateproduct&token={getAdminToken tab='AdminProducts'}">
		<span class="productName">{$product['product_name']}</span><br />
		{if $product.product_reference}{l s='Ref:'} {$product.product_reference}<br />{/if}
		{if $product.product_supplier_reference}{l s='Ref Supplier:'} {$product.product_supplier_reference}{/if}
	</a>
	</td>
	<td>
		<span class="product_price_show">{displayPrice price=$product_price currency=$currency->id}</span>
		{if $can_edit || Configuration::get('PS_EDS')}
		<span class="product_price_edit" style="display:none;">
			<input type="hidden" name="product_id_order_detail" class="edit_product_id_order_detail" value="{$product['id_order_detail']}" />
			{if $currency->sign % 2}
			{$currency->sign}
			{/if}
			<input type="text" name="product_price_tax_excl" class="edit_product_price_tax_excl edit_product_price" value="{Tools::ps_round($product['unit_price_tax_excl'], 2)}"/>
			{if !($currency->sign % 2)}{$currency->sign}{/if}
			{l s='tax excl.'}<br />
			{if $currency->sign % 2}{$currency->sign}{/if}
			<input type="text" name="product_price_tax_incl" class="edit_product_price_tax_incl edit_product_price" value="{Tools::ps_round($product['unit_price_tax_incl'], 2)}"/>
			{if !($currency->sign % 2)}{$currency->sign}{/if} {l s='tax incl.'}
		</span>
		{/if}
	</td>
	<td class="productQuantity">
		<span class="product_quantity_show{if (int)$product['product_quantity'] > 1} red bold{/if}">{$product['product_quantity']}</span>
		{if $can_edit || Configuration::get('PS_EDS')}
		<span class="product_quantity_edit" style="display:none;">
			<input type="text" name="product_quantity" class="edit_product_quantity" value="{$product['product_quantity']|htmlentities}"/>
		</span>
		{/if}
	</td>
	{if $display_warehouse}<td align="center">{$product.warehouse_name|escape:'html':'UTF-8'}</td>{/if}
	{if ($order->hasBeenPaid())}
		<td class="productQuantity">
			{$product['product_quantity_refunded']}
			{if count($product['refund_history'])}
				<span class="tooltip">
					<span class="tooltip_label tooltip_button">+</span>
					<div class="tooltip_content">
					<span class="title">{l s='Refund history'}</span>
					{foreach $product['refund_history'] as $refund}
						{l s='%1s - %2s' sprintf=[{dateFormat date=$refund.date_add}, {displayPrice price=$refund.amount_tax_incl}]}<br />
					{/foreach}
					</div>
				</span>
			{/if}
		</td>
	{/if}
	{if $order->hasBeenDelivered() || $order->hasProductReturned()}
		<td class="productQuantity">
			{$product['product_quantity_return']}
			{if isset($product['return_history'])}
				{if count($product['return_history'])}
					<span class="tooltip">
						<span class="tooltip_label tooltip_button">+</span>
						<div class="tooltip_content">
						<span class="title">{l s='Return history'}</span>
						{foreach $product['return_history'] as $return}
							{l s='%1s - %2s - %3s' sprintf=[{dateFormat date=$return.date_add}, $return.product_quantity, $return.state]}<br />
						{/foreach}
						</div>
					</span>
				{/if}
			{/if}
		</td>
	{/if}
	{if $stock_management}<td class="productQuantity product_stock">{$product['current_stock']}</td>{/if}
	<td class="total_product">
		{displayPrice price=(Tools::ps_round($product_price, 2) * ($product['product_quantity'] - $product['customizationQuantityTotal'])) currency=$currency->id}
	</td>
	<td colspan="2" style="display: none;" class="add_product_fields">&nbsp;</td>
	<td class="cancelCheck standard_refund_fields current-edit" style="display:none">
		<input type="hidden" name="totalQtyReturn" id="totalQtyReturn" value="{$product['product_quantity_return']}" />
		<input type="hidden" name="totalQty" id="totalQty" value="{$product['product_quantity']}" />
		<input type="hidden" name="productName" id="productName" value="{$product['product_name']}" />
	{if ((!$order->hasBeenDelivered() OR Configuration::get('PS_ORDER_RETURN')) AND (int)($product['product_quantity_return']) < (int)($product['product_quantity']))}
		<input type="checkbox" name="id_order_detail[{$product['id_order_detail']}]" id="id_order_detail[{$product['id_order_detail']}]" value="{$product['id_order_detail']}" onchange="setCancelQuantity(this, {$product['id_order_detail']}, {$product['product_quantity'] - $product['customizationQuantityTotal'] - $product['product_quantity_return']})" {if ($product['product_quantity_return'] + $product['product_quantity_refunded'] >= $product['product_quantity'])}disabled="disabled" {/if}/>
	{else}
		--
	{/if}
	</td>
	<td class="cancelQuantity standard_refund_fields current-edit" style="display:none">
	{if ($product['product_quantity_return'] + $product['product_quantity_refunded'] >= $product['product_quantity'])}
		<input type="hidden" name="cancelQuantity[{$product['id_order_detail']}]" value="0" />
	{elseif (!$order->hasBeenDelivered() OR Configuration::get('PS_ORDER_RETURN'))}
		<input type="text" id="cancelQuantity_{$product['id_order_detail']}" name="cancelQuantity[{$product['id_order_detail']}]" onclick="selectCheckbox(this);" value="" />
	{/if}

	{if $product['customizationQuantityTotal']}
		{assign var=productQuantity value=($product['product_quantity']-$product['customizationQuantityTotal'])}
	{else}
		{assign var=productQuantity value=$product['product_quantity']}
	{/if}

	{if ($order->hasBeenDelivered())}
		{$product['product_quantity_refunded']}/{$productQuantity-$product['product_quantity_refunded']}
	{elseif ($order->hasBeenPaid())}
		{$product['product_quantity_return']}/{$productQuantity}
	{else}
		0/{$productQuantity}
	{/if}
	</td>
	<td class="partial_refund_fields current-edit" style="display:none;">

		<div class="form-group">
			<div class="col-lg-6 fixed-width-lg">
				<label class="control-label">
					{l s='Quantity:'}
				</label>
				<div class="input-group">
					<input onchange="checkPartialRefundProductQuantity(this)" type="text" name="partialRefundProductQuantity[{{$product['id_order_detail']}}]" value="0" />
					<div class="input-group-addon">0/{$productQuantity-$product['product_quantity_refunded']}</div>
				</div>
			</div>
			<div class="col-lg-6 fixed-width-lg">
				<label class="control-label">
					{l s='Amount:'}
				</label>
				<div class="input-group">
					<div class="input-group-addon">
						{$currency->prefix}
						{$currency->suffix}
					</div>
					<input onchange="checkPartialRefundProductAmount(this)" type="text" name="partialRefundProduct[{$product['id_order_detail']}]" />
				</div>
			</div>
		</div>

		<div class="form-group">
			{if !empty($product['amount_refund']) && $product['amount_refund'] > 0}
				({l s='%s refund' sprintf=$product['amount_refund']})
			{/if}
			<input type="hidden" value="{$product['quantity_refundable']}" class="partialRefundProductQuantity" />
			<input type="hidden" value="{$product['amount_refundable']}" class="partialRefundProductAmount" />		
		</div>
	
	</td>
	{if ($can_edit && !$order->hasBeenDelivered())}
	<td class="product_invoice" colspan="2" style="display: none;">
		{if Configuration::get('PS_EDS') && Configuration::get('PS_EDS_INVOICE_DELIVERED')}
		 &nbsp;
		 {else}
			{if sizeof($invoices_collection)}
			<select name="product_invoice" class="edit_product_invoice">
				{foreach from=$invoices_collection item=invoice}
				<option value="{$invoice->id}" {if $invoice->id == $product['id_order_invoice']}selected="selected"{/if}>
					#{Configuration::get('PS_INVOICE_PREFIX', $current_id_lang, null, $order->id_shop)}{'%06d'|sprintf:$invoice->number}
				</option>
				{/foreach}
			</select>
			{else}
			&nbsp;
			{/if}
		{/if}
	</td>
	{/if}
	{if ( ($can_edit && !$order->hasBeenDelivered()) || Configuration::get('PS_EDS'))}
	<td class="product_action">
		{* edit/delete controls *}
		<div class="btn-group">
			<button type="button" class="btn btn-default edit_product_change_link">
				<i class="icon-pencil"></i>
				{l s='Edit'}
			</button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<li>
					<a href="#" class="delete_product_line">
						<i class="icon-trash"></i>
						{l s='Delete'}
					</a>
				</li>
			</ul>
		</div>
		{* Update controls *}
		<button type="button" class="btn btn-default submitProductChange" style="display: none;">
			<i class="icon-ok"></i>
			{l s='Update'}
		</button>
		<button type="button" class="btn btn-default cancel_product_change_link" style="display: none;">
			<i class="icon-remove"></i>
			{l s='Cancel'}
		</button>

	</td>
	{/if}
</tr>
{/if}
