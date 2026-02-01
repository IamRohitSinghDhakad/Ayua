//
//  WebServiceHelper.swift
//  Somi
//
//  Created by Paras on 24/03/21.
//

import Foundation
import UIKit


let BASE_URL = "https://ambitious.in.net/Shubham/ayua/index.php/api/"//Local

struct WsUrl{
    
    static let url_LogIn  = BASE_URL + "login"
    static let url_SignUp = BASE_URL + "signup"
    static let url_getBanner = BASE_URL + "get_banners"
    static let url_ForgotPassword = BASE_URL + "forgot_password"
    static let url_getUserProfile  = BASE_URL + "get_profile"
    static let url_getCategory  = BASE_URL + "get_category"
    static let url_getSubCategory  = BASE_URL + "get_sub_category"
    static let url_getUserJobs  = BASE_URL + "get_user_jobs"
    static let url_getProviderJobs  = BASE_URL + "get_provider_jobs"
    static let url_place_bid  = BASE_URL + "place_bid"
    static let url_get_wallet  = BASE_URL + "get_wallet"
    static let url_get_subscription  = BASE_URL + "get_subscription"
    static let url_get_review  = BASE_URL + "get_rating"
    static let url_update_profile  = BASE_URL + "update_profile"
    static let url_contact_us  = BASE_URL + "contact_us"
    
    static let url_GetConversation = BASE_URL + "get_conversation"
    static let url_GetNotification = BASE_URL + "get_notification"
    static let url_InsertChat = BASE_URL + "insert_chat"
    static let url_GetChat = BASE_URL + "get_chat"
    static let url_Create_Payment = BASE_URL + "create_payment"
    static let url_create_job = BASE_URL + "create_job"
    static let url_GetAccount = BASE_URL + "get_accounts"
    static let url_SaveAccount = BASE_URL + "save_account"
    static let url_withdrawal_request = BASE_URL + "withdrawal_request"
    static let url_PrivacyPolicy = "page?page=Privacy%20Policy&lang=en"
    static let url_Terms = "page?page=Terms%20Conditions&lang=en"
  
    static let url_ReportUser = BASE_URL + "report_user"
    static let url_BlockUser = BASE_URL + "block_user"
    static let url_DeleteAccunt = BASE_URL + "delete_user?user_id="
    static let url_deleteChatSingleMessage = BASE_URL + "delete_a_message?"
    static let url_clearConversation = BASE_URL + "clear_conversation"
    static let url_get_bids = BASE_URL + "get_bids"
    static let url_update_job_status = BASE_URL + "update_job_status"
    static let url_review_rating = BASE_URL + "review_rating"
    
    static let url_getConfirmationStatus  = BASE_URL + "update_confirmation_status"
    static let url_extendMissionTime  = BASE_URL + "extend_time"
   
}


//Api Header

struct WsHeader {

    //Login

    static let deviceId = "Device-Id"

    static let deviceType = "Device-Type"

    static let deviceTimeZone = "Device-Timezone"

    static let ContentType = "Content-Type"

}



//Api check for params
struct WsParamsType {
    static let PathVariable = "Path Variable"
    static let QueryParams = "Query Params"
}



/*
 public interface LoadInterface {

     @POST("login")
     Call<ResponseBody> login(@Query("mobile") String mobile,
                              @Query("password") String password,
                              @Query("type") String type,
                              @Query("device_type") String device_type,
                              @Query("register_id") String device_token,
                              @Query("lang") String language);

     @POST("forgot_password")
     Call<ResponseBody> forgot_password(@Query("mobile") String mobile,
                                        @Query("lang") String language);

     @POST("signup")
     Call<ResponseBody> signup(@Query("name") String name,
                               @Query("mobile") String mobile,
                               @Query("password") String password,
                               @Query("type") String type,
                               @Query("category_id") String category_id,
                               @Query("sub_category_id") String sub_category_id,
                               @Query("device_type") String device_type,
                               @Query("register_id") String device_token,
                               @Query("lang") String language);

     @POST("verify_otp")
     Call<ResponseBody> verify_otp(@Query("user_id") String user_id,
                                   @Query("mobile") String mobile,
                                   @Query("otp") String otp,
                                   @Query("lang") String language);

     @POST("get_category")
     Call<ResponseBody> get_category(@Query("user_id") String user_id,
                                     @Query("lang") String language);

     @POST("get_sub_category")
     Call<ResponseBody> get_sub_category(@Query("category_id") String category_id,
                                         @Query("lang") String language);

     @POST("contact_us")
     Call<ResponseBody> contact_us(@Query("user_id") String user_id,
                                   @Query("subject") String subject,
                                   @Query("message") String message,
                                   @Query("lang") String language);

     @POST("get_profile")
     Call<ResponseBody> get_profile(@Query("login_user_id") String login_user_id,
                                    @Query("lang") String language);


     @Multipart
     @POST("update_profile")
     Call<ResponseBody> update_profile(@Query("user_id") String user_id,
                                       @Query("name") String name,
                                       @Query("mobile") String mobile,
                                       @Query("password") String password,
                                       @Query("category_id") String category_id,
                                       @Query("sub_category_id") String sub_category_id,
                                       @Query("lang") String language,
                                       @Part MultipartBody.Part body1);

     @POST("get_banners")
     Call<ResponseBody> get_banner(@Query("lang") String language);

     @Multipart
     @POST("create_job")
     Call<ResponseBody> create_job(@Query("user_id") String user_id,
                                   @Query("category_id") String category_id,
                                   @Query("sub_category_id") String sub_category_id,
                                   @Query("detail") String details,
                                   @Query("address") String address,
                                   @Query("lat") String lat,
                                   @Query("lng") String lng,
                                   @Query("drop_addres") String drop_addres,
                                   @Query("drop_lat") String drop_lat,
                                   @Query("drop_lng") String drop_lng,
                                   @Query("lang") String language,
                                   @Part MultipartBody.Part body1,
                                   @Part MultipartBody.Part body2,
                                   @Part MultipartBody.Part body3,
                                   @Part MultipartBody.Part body4);

     @POST("get_user_jobs")
     Call<ResponseBody> get_user_jobs(@Query("job_id") String job_id,
                                      @Query("user_id") String user_id,
                                      @Query("status") String status,
                                      @Query("lang") String language);

     @POST("get_virtual_plans")
     Call<ResponseBody> get_virtual_plans(@Query("lang") String language);

     @POST("get_membership_plans")
     Call<ResponseBody> get_membership_plans(@Query("user_id") String user_id,
                                             @Query("lang") String language);

     @POST("take_coins")
     Call<ResponseBody> take_coins(@Query("user_id") String user_id,
                                   @Query("plan_id") String plan_id,
                                   @Query("lang") String language);

     @POST("take_membership")
     Call<ResponseBody> take_membership(@Query("user_id") String user_id,
                                   @Query("plan_id") String plan_id,
                                   @Query("lang") String language);

     @POST("get_provider_jobs")
     Call<ResponseBody> get_provider_jobs(@Query("job_id") String job_id,
                                          @Query("provider_id") String provider_id,
                                          @Query("status") String status,
                                          @Query("lat") String lat,
                                          @Query("lng") String lng,
                                          @Query("lang") String language);

     @POST("get_provider_jobs")
     Call<ResponseBody> get_provider_jobs2(@Query("job_id") String job_id,
                                           @Query("provider_id") String provider_id,
                                           @Query("lat") String lat,
                                           @Query("lng") String lng,
                                           @Query("lang") String language);

     @POST("get_jobs")
     Call<ResponseBody> get_jobs(@Query("job_id") String job_id,
                                 @Query("user_id") String user_id,
                                 @Query("employee_id") String employee_id,
                                 @Query("status") String status,
                                 @Query("lang") String language);

     @POST("place_bid")
     Call<ResponseBody> place_bid(@Query("job_id") String job_id,
                                  @Query("provider_id") String provider_id,
                                  @Query("bid_amount") String bid_amount,
                                  @Query("date") String date,
                                  @Query("time") String time,
                                  @Query("proposal") String proposal,
                                  @Query("lang") String language);

     @POST("get_bids")
     Call<ResponseBody> get_bids(@Query("job_id") String job_id,
                                 @Query("lang") String language);

     @POST("update_job_status")
     Call<ResponseBody> update_job_status(@Query("job_id") String job_id,
                                          @Query("provider_id") String provider_id,
                                          @Query("status") String status,
                                          @Query("lang") String language);


     @POST("create_payment")
     Call<ResponseBody> create_milestone(@Query("job_id") String job_id,
                                         @Query("amount") String amount,
                                         @Query("currency") String currency,
                                         @Query("lang") String language);

     @POST("review_rating")
     Call<ResponseBody> review_rating(@Query("job_id") String job_id,
                                      @Query("from") String from,
                                      @Query("to") String to,
                                      @Query("rating") String rating,
                                      @Query("review") String review,
                                      @Query("lang") String language);


     @POST("get_chat")
     Call<ResponseBody> getChat(@Query("sender_id") String sender_id,
                                @Query("receiver_id") String receiver_id,
                                @Query("job_id") String job_id,
                                @Query("lang") String language);

     @Multipart
     @POST("insert_chat")
     Call<ResponseBody> insertChat(@Query("sender_id") String sender_id,
                                   @Query("receiver_id") String receiver_id,
                                   @Query("job_id") String job_id,
                                   @Query("chat_message") String chat_message,
                                   @Query("type") String type,
                                   @Query("lang") String language,
                                   @Part MultipartBody.Part body);

     @POST("delete_message")
     Call<ResponseBody> delete_message(@Query("user_id") String user_id,
                                       @Query("message_id") String message_id);

     @POST("update_chat")
     Call<ResponseBody> update_chat(@Query("chat_id") String chat_id,
                                    @Query("sender_path") String sender_path,
                                    @Query("receiver_path") String receiver_path);

     @POST("get_conversation")
     Call<ResponseBody> get_conversation(@Query("user_id") String user_id,
                                         @Query("lang") String language);

     @POST("get_subscription")
     Call<ResponseBody> get_subscription(@Query("user_id") String user_id,
                                         @Query("lang") String language);


     @POST("get_rating")
     Call<ResponseBody> get_rating(@Query("user_id") String user_id,
                                   @Query("lang") String language);

     @POST("get_wallet")
     Call<ResponseBody> get_wallet(@Query("employee_id") String employee_id,
                                   @Query("lang") String language);

     @POST("get_accounts")
     Call<ResponseBody> get_accounts(@Query("user_id") String user_id,
                                     @Query("lang") String language);

     @POST("save_account")
     Call<ResponseBody> save_account(@Query("user_id") String user_id,
                                     @Query("bank_name") String bank_name,
                                     @Query("holder_name") String holder_name,
                                     @Query("account_number") String account_number,
                                     @Query("ifsc") String ifsc);

 //    @Query("language") String language

     @POST("withdrawal_request")
     Call<ResponseBody> withdrawal_request(@Query("employee_id") String employee_id,
                                           @Query("amount") String amount,
                                           @Query("language") String language);

 }
 */
