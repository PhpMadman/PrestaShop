<?php
/*
* 2007-2013 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
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
*  @copyright  2007-2013 PrestaShop SA
*  @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

// Remember to refresh cache, and you also might need to delete cache/class_index.php

class Order extends OrderCore
{
	/**
	 * Generate a unique reference for orders generated with the same cart id
	 * This references, is usefull for check payment
	 *
	 * @return String
	 */
	public static function generateReference($id_order,$id_shop)
	{
		$order_number = sprintf('%06d',$id_order);
		if (Configuration::get('PS_MULTISHOP_FEATURE_ACTIVE'))
			$order_number = $id_shop.$order_number;

		return $order_number;
	}
}
?>
