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
	</td>
	<td class="productQuantity">
		<span class="product_quantity_show{if (int)$product['product_quantity'] > 1} red bold{/if}">{$product['product_quantity']}</span>
	</td>
	{if $display_warehouse}<td align="center">{$product.warehouse_name|escape:'html':'UTF-8'}</td>{/if}
	<td class="total_product">
		{displayPrice price=(Tools::ps_round($product_price, 2) * ($product['product_quantity'] - $product['customizationQuantityTotal'])) currency=$currency->id}
	</td>
</tr>
{/if}
