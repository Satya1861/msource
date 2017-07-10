//
//  Constants.h
//  DemoSharingApp
//
//  Created by Sonali on 23/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#ifndef DemoSharingApp_Constants_h
#define DemoSharingApp_Constants_h

#define applicationID @"34kw1RSNbc52ki5ggls8KTrAuXvtzLxSWrj5GxlB"
#define clientkey @"N2wsmMt5991pylA5dX5VNmo7DquAL9dk61l3muy3"
#define restAPIkey @"yPCAfUAS0SWrgpF1zBW8RL9vllunPiH6PxgelnVJ"

//#define restServerBaseUrl @"https://34kw1RSNbc52ki5ggls8KTrAuXvtzLxSWrj5GxlB:javascript-key:3050S0bFnbrKaKmF1tVpkOUp8uVknATweuLoGpRi@api.parse.com/1/classes/"



#define restServerUrl @"http://34.209.23.24:1338/parse/classes/"

#define restCloudUrl @"http://34.209.23.24:1338/parse/functions/"

#define folderUrl @"getPhotos"

#define submitAnswerUrl @"submitAnswer"

#define alreadyReg @"AppUser?where={\"deviceInfo\": { \"__type\": \"Pointer\",         \"className\": \"_Installation\",         \"objectId\": \"OBJECTID\"}}"

#define fixturesURL @"Fixtures?&include=team1Id&include=team2Id&include=groupId&include=stadiumId&where={\"isPast\": false}&order=dateOfMatch"

#define resultsUrl @"getResults"

#define quizRulesUrl @"QuizRules"



#define helpDeskUrl @"HelpDesk"

#define questionsUrl @"getQuestions"

#define NotificationUrl @"NotificationHistory?order=-createdAt"

#define summary @"Summary?where={\"fixturesId\":{\"__type\":\"Pointer\",\"className\":\"Fixtures\",\"objectId\":\"OBJECTID\"}}&include=fixturesId&include=fixturesId.stadiumId&include=fixturesId.team1Id&include=fixturesId.team2Id"

#define standingsUrl @"getPoints"

#define zonalStandingsUrl @"getPointsZonal"

#define membersURL @"Members?where={\"teamId\":{\"__type\":\"Pointer\",\"className\":\"Team\",\"objectId\":\"OBJECTID\"}}&include=teamId"

#define submitReminderUrl @"ReminderHistory"

#define reminderHistoryUrl @"ReminderHistory?where={  \"appUserId\": {    \"__type\": \"Pointer\",    \"className\": \"AppUser\",    \"objectId\": \"APPUSERID\"  },  \"fixturesId\": {    \"__type\": \"Pointer\",    \"className\": \"Fixtures\",    \"objectId\": \"OBJECTID\"  }}"

#define scheduleURL @"Schedule?order=startDate"

#define aboutUsDataUrl @"HostCity"

#define twitterUrl @"Twitter"

#define teamURL @"Team?where={\"isZonal\":false}&include=groupId&order=teamName"

#define zonalteamURL @"Team?where={\"isZonal\":true}&include=groupId&order=teamName"

#define landingUrl @"LandingPageImage"

#define speakerURL @"Speaker?order=name"

#define sponsorURL @"Sponsors?order=-createdAt"

#define speakersForScheduleURL @"Speaker?where={\"objectId\":{\"$in\":[USEROBJECTID]}}"

#define dowloadURL @"Downloads?include=scheduleType,order=-createdAt"

#define dowloadForScheduleURL @"Downloads?where={\"scheduleType\":{\"__type\":\"Pointer\",\"className\":\"Schedule\",\"objectId\":\"SCHEDULEID\"}}&include=scheduleType"

#define photosURL @"Photos?order=-createdAt"

#define sessionUrl @"Sessions?where={\"scheduleType\":{\"__type\":\"Pointer\",\"className\":\"Schedule\",\"objectId\":\"OBJECTID\"}}&include=scheduleType&order=startTime"

#define surveyURL @"Survey?order=startTime&limit=1000"

#define surveyQuesURL @"SurveyQuestion?where={\"surveyType\":{\"__type\":\"Pointer\",\"className\":\"Survey\",\"objectId\":\"OBJECTID\"}}&include=survey"

#define quizURL @"Quiz?&order=startTime&limit=1000"

#define quizQuesURL @"QuizQuestion?where={\"quizType\":{\"__type\":\"Pointer\",\"className\":\"Quiz\",\"objectId\":\"OBJECTID\"}}&include=quiz&order=number"

#endif
