/**
 * Lingua::Poly OpenAPI WebApp
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 1.0
 * 
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */


/**
 * Either the oldPassword or a reset token must be present.
 */
export interface PasswordChange { 
    oldPassword?: string;
    resetToken?: string;
    password: string;
}

