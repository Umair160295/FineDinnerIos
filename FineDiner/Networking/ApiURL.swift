//
//  ApiURL.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import Foundation
var BASE_URL = "https://app.finediner.co/api/"

var REGISTER_URL = BASE_URL + "auth/register"
var VERIFY_URL = BASE_URL + "auth/verifyPhone"
var CHECK_CODE_URL = BASE_URL + "auth/verifyPhone/check-code"
var LOGIN_URL = BASE_URL + "auth/login"
var LOGIN_SOCIAL_URL = BASE_URL + "auth/login-social"
var FORGOT_PASS_URL = BASE_URL + "auth/forgot-password"
var RESET_PASS_URL = BASE_URL + "auth/reset-password"
var RESET_CODE_URL = BASE_URL + "auth/verifyPhone/reset-code"
var GET_PROFILE_URL = BASE_URL + "user"
var UPDATE_PROFILE_URL = BASE_URL + "user/update"
var UPDATE_PASSWORD_URL = BASE_URL + "user/update-password"
var UPDATE_PHONE_URL = BASE_URL + "user/update/phone_number"

var GET_CITY_URL = BASE_URL + "app/city"
var GET_AREA_URL = BASE_URL + "app/area?city_id="
var GET_MENU_URL = BASE_URL + "menu"
var GET_GROUP_MAIN_URL = BASE_URL + "group_main"
var GET_PRODUCTS_URL = BASE_URL + "products"
var CART_URL = BASE_URL + "cart"
var ORDER_TIME_URL = BASE_URL + "orders/order_time"
var ADDRESS_URL = BASE_URL + "user/address"
var FAVORITE_URL = "/favorite"
var REVIEW_URL = "/review"
var NOTIFICATION_URL = BASE_URL + "notification"
var ORDER_URL = BASE_URL + "orders"
var PAYMENT_URL = BASE_URL + "payment/requestsavecard"
var PROMO_CODE_URL = ORDER_URL + "/promo-code"
var CHECK_APPLE_LOGIN_URL = BASE_URL + "app/check-apply-login"
var DELETE_Account_URL = BASE_URL + "user/delete"
var VERSION_UPDATE = "https://app.finediner.co/api/v2/user/device-token"
var Card_url = BASE_URL + "user/creditcards"

var CheckOut_url = BASE_URL + "payment/paybyusercard"

var delete_card_url = BASE_URL + "payment/removecard_t"

var update_address_url = BASE_URL + "user/address/"

var checkout_url = BASE_URL + "payment/createorder"
var tokenize_request_t_url = BASE_URL + "payment/tokenize_request_t"
var payment_pay_order_t_url = BASE_URL + "payment/pay_order_t"
