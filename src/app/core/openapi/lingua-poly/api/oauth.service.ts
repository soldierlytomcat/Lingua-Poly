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
/* tslint:disable:no-unused-variable member-ordering */

import { Inject, Injectable, Optional }                      from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams,
         HttpResponse, HttpEvent, HttpParameterCodec }       from '@angular/common/http';
import { CustomHttpParameterCodec }                          from '../encoder';
import { Observable }                                        from 'rxjs';


import { BASE_PATH, COLLECTION_FORMATS }                     from '../variables';
import { Configuration }                                     from '../configuration';


@Injectable({
  providedIn: 'root'
})
export class OauthService {

    protected basePath = 'http://localhost:4200/api/lingua-poly/users/v1';
    public defaultHeaders = new HttpHeaders();
    public configuration = new Configuration();
    public encoder: HttpParameterCodec;

    constructor(protected httpClient: HttpClient, @Optional()@Inject(BASE_PATH) basePath: string, @Optional() configuration: Configuration) {
        if (configuration) {
            this.configuration = configuration;
        }
        if (typeof this.configuration.basePath !== 'string') {
            if (typeof basePath !== 'string') {
                basePath = this.basePath;
            }
            this.configuration.basePath = basePath;
        }
        this.encoder = this.configuration.encoder || new CustomHttpParameterCodec();
    }



    /**
     * Google OpenID Connect Redirect URL
     * @param error An error occured.
     * @param code Code for access token.
     * @param clientId The Google Client ID.
     * @param clientSecret The Google Client secret.
     * @param redirectUri The redirect URI used
     * @param grantType Always \&quot;authorization_code\&quot;.
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public oauthGoogleGet(error?: string, code?: string, clientId?: string, clientSecret?: string, redirectUri?: string, grantType?: 'authorization_code', observe?: 'body', reportProgress?: boolean): Observable<any>;
    public oauthGoogleGet(error?: string, code?: string, clientId?: string, clientSecret?: string, redirectUri?: string, grantType?: 'authorization_code', observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<any>>;
    public oauthGoogleGet(error?: string, code?: string, clientId?: string, clientSecret?: string, redirectUri?: string, grantType?: 'authorization_code', observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<any>>;
    public oauthGoogleGet(error?: string, code?: string, clientId?: string, clientSecret?: string, redirectUri?: string, grantType?: 'authorization_code', observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let queryParameters = new HttpParams({encoder: this.encoder});
        if (error !== undefined && error !== null) {
            queryParameters = queryParameters.set('error', <any>error);
        }
        if (code !== undefined && code !== null) {
            queryParameters = queryParameters.set('code', <any>code);
        }
        if (clientId !== undefined && clientId !== null) {
            queryParameters = queryParameters.set('client_id', <any>clientId);
        }
        if (clientSecret !== undefined && clientSecret !== null) {
            queryParameters = queryParameters.set('client_secret', <any>clientSecret);
        }
        if (redirectUri !== undefined && redirectUri !== null) {
            queryParameters = queryParameters.set('redirect_uri', <any>redirectUri);
        }
        if (grantType !== undefined && grantType !== null) {
            queryParameters = queryParameters.set('grant_type', <any>grantType);
        }

        let headers = this.defaultHeaders;

        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        return this.httpClient.get<any>(`${this.configuration.basePath}/oauth/google`,
            {
                params: queryParameters,
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

}