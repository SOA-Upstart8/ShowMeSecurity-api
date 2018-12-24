# ShowMeSecurity-api

## Overview
Some people are curious about what are the latest security issues or news they should be careful. But there are too many information on the Internet, resulting in people can't easily find what they want or need. So we will integrate and classify data that we get from SecBuzzer and News API. Provide a useful and friendly website for everyone to use.
The website has three main function:
1. First, We provide the latest/hottest security issues or vulnerabilities to user.
2. Secound, We classify the issues to make searching more convenient for users.
3. Third, Every issue we will attach expert opinions from twitter and solution(If it exists).

## Routes

### Root check

`GET /`

Status:

- 200: API server running (happy)

### Return database data
(Get all CVEs from SMS api)
`GET /api/v1/cves/`

Status
- 200: CVEs returned (happy)
- 404: url is wrong (sad)
- 500: problems with SMS api (bad)

### Return filtered OWASP TOP10 CVEs
`POST /api/v1/cves/{owasp}`

Status
- 200: CVEs returned (happy)
- 404: query is wrong (sad)
- 500: server error (sad)

### Search CVEs by query
`POST /api/v1/search/{query}`

Status
- 200: CVEs returned (happy)
- 404: query is wrong (sad)
- 500: server error (sad)

### Get latest CVEs
`GET /api/v1/latest`

Status
- 200: CVEs returned (happy)
- 500: server error (sad)

### Return number of CVEs for every month
`GET /api/v1/analysis/month`

Status
- 200: CVEs returned (happy)
- 500: server error (sad)

### Return top 5 CVEs for 2018
`GET /api/v1/top_5`

Status
- 200: CVEs returned (happy)
- 500: server error (sad)