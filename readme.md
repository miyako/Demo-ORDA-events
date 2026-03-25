# 5. 整合性を保証

## `Google`トークンの管理

`/PACKAGE/Secrets`に下記の要領で秘密ファイルを用意します。

- `Secrets/Google-settings.json`

```json
{
	"name": "Google",
	"permission": "signedIn",
	"clientId": "************-********************************.apps.googleusercontent.com",
	"clientSecret": "GOCSPX-****************************",
	"redirectURI": "http://127.0.0.1:50993/authorize/",
	"scope": "https://www.googleapis.com/auth/gmail.send"
}
```

- `Secrets/Google.json`

```json
{
	"access_token": "****.*******************************************-*-********-**********************************************************************-**********************************************-*********************************************************************-*****",
	"expires_in": 3599,
	"refresh_token": "*******************************-***********************-***********************************************",

	"scope": "https://www.googleapis.com/auth/gmail.send",
	"token_type": "Bearer"
}
``` 
