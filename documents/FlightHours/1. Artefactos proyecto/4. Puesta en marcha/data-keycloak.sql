-- MySQL dump 10.13  Distrib 8.0.45, for Linux (aarch64)
--
-- Host: localhost    Database: keycloakDb
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ADMIN_EVENT_ENTITY`
--

DROP TABLE IF EXISTS `ADMIN_EVENT_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ADMIN_EVENT_ENTITY` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ADMIN_EVENT_TIME` bigint DEFAULT NULL,
  `REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPERATION_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AUTH_REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AUTH_CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AUTH_USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ADDRESS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_PATH` text COLLATE utf8mb4_unicode_ci,
  `REPRESENTATION` text COLLATE utf8mb4_unicode_ci,
  `ERROR` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_TYPE` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DETAILS_JSON` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`ID`),
  KEY `IDX_ADMIN_EVENT_TIME` (`REALM_ID`,`ADMIN_EVENT_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ADMIN_EVENT_ENTITY`
--

LOCK TABLES `ADMIN_EVENT_ENTITY` WRITE;
/*!40000 ALTER TABLE `ADMIN_EVENT_ENTITY` DISABLE KEYS */;
/*!40000 ALTER TABLE `ADMIN_EVENT_ENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ASSOCIATED_POLICY`
--

DROP TABLE IF EXISTS `ASSOCIATED_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ASSOCIATED_POLICY` (
  `POLICY_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ASSOCIATED_POLICY_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`POLICY_ID`,`ASSOCIATED_POLICY_ID`),
  KEY `IDX_ASSOC_POL_ASSOC_POL_ID` (`ASSOCIATED_POLICY_ID`),
  CONSTRAINT `FK_FRSR5S213XCX4WNKOG82SSRFY` FOREIGN KEY (`ASSOCIATED_POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`),
  CONSTRAINT `FK_FRSRPAS14XCX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ASSOCIATED_POLICY`
--

LOCK TABLES `ASSOCIATED_POLICY` WRITE;
/*!40000 ALTER TABLE `ASSOCIATED_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `ASSOCIATED_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATION_EXECUTION`
--

DROP TABLE IF EXISTS `AUTHENTICATION_EXECUTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATION_EXECUTION` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AUTHENTICATOR` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FLOW_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REQUIREMENT` int DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  `AUTHENTICATOR_FLOW` tinyint NOT NULL DEFAULT '0',
  `AUTH_FLOW_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AUTH_CONFIG` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_AUTH_EXEC_REALM_FLOW` (`REALM_ID`,`FLOW_ID`),
  KEY `IDX_AUTH_EXEC_FLOW` (`FLOW_ID`),
  CONSTRAINT `FK_AUTH_EXEC_FLOW` FOREIGN KEY (`FLOW_ID`) REFERENCES `AUTHENTICATION_FLOW` (`ID`),
  CONSTRAINT `FK_AUTH_EXEC_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATION_EXECUTION`
--

LOCK TABLES `AUTHENTICATION_EXECUTION` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATION_EXECUTION` DISABLE KEYS */;
INSERT INTO `AUTHENTICATION_EXECUTION` (`ID`, `ALIAS`, `AUTHENTICATOR`, `REALM_ID`, `FLOW_ID`, `REQUIREMENT`, `PRIORITY`, `AUTHENTICATOR_FLOW`, `AUTH_FLOW_ID`, `AUTH_CONFIG`) VALUES ('02e8f679-fd71-4b82-8120-d539a01fccd7',NULL,'registration-recaptcha-action','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','a988487c-3af5-49f0-83f2-5628b0a924c4',3,60,0,NULL,NULL),('0438457f-adf2-4c5c-b67b-5e4892d8802e',NULL,'auth-cookie','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','4338d86a-1c34-4feb-8a91-d755c001a5ec',2,10,0,NULL,NULL),('0598d61c-3e5e-4358-856c-8cbc779c77b7',NULL,'auth-otp-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ced49546-0ec2-4913-9e3b-62185ba82c47',2,30,0,NULL,NULL),('0a249d7b-47c8-4e50-87be-64fde5e6c945',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','de0b828f-221b-476b-b283-f2c09e6810bc',2,20,1,'d4ddf960-43b9-4971-9adf-b7319ec63a26',NULL),('104e1049-7bdd-4447-ad69-64286aa1e522',NULL,'conditional-user-configured','c873670d-8167-4205-af33-8519fdff5955','ac6c1ade-7cf1-4185-b085-bb19ad6600a8',0,10,0,NULL,NULL),('128ca7a9-f449-47c5-9fd3-f3bdc81f03bc',NULL,'client-x509','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','6bf32edd-2aa5-437e-a001-eceddcbea9da',2,40,0,NULL,NULL),('14f54c1b-d2ae-4de9-89a5-a46ed9bfde42',NULL,'webauthn-authenticator','c873670d-8167-4205-af33-8519fdff5955','ac6c1ade-7cf1-4185-b085-bb19ad6600a8',3,40,0,NULL,NULL),('1836f978-c6b2-4612-bf9f-b89d05e7bc02',NULL,'identity-provider-redirector','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','4338d86a-1c34-4feb-8a91-d755c001a5ec',2,25,0,NULL,NULL),('1b58173b-7661-4d1c-b383-a5fb28bfced4',NULL,'idp-add-organization-member','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','6aa5f2fc-e3cf-4343-af2c-6cd11085078c',0,20,0,NULL,NULL),('20115224-a80b-47fa-8268-416dd2f4d7c4',NULL,'idp-create-user-if-unique','c873670d-8167-4205-af33-8519fdff5955','d6f8dbdc-38f6-49e7-84d3-31f5aa4121a3',2,10,0,NULL,'91d0ec7a-49f1-4d17-bcc3-61b334daf63e'),('20401d40-5268-4fad-8f28-e25b1bfeb72e',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0ac6313f-2df3-4199-8de0-23834861dc55',1,20,1,'2085d5cb-6b96-4e4a-b181-dad2f8e1e87a',NULL),('20a085ab-7d2b-4793-8c2f-f48e28c6da16',NULL,'auth-spnego','c873670d-8167-4205-af33-8519fdff5955','23dba624-31ac-4a4a-867f-6d43e0312d35',3,20,0,NULL,NULL),('241b2a05-926d-497b-8690-5e814c93e211',NULL,'identity-provider-redirector','c873670d-8167-4205-af33-8519fdff5955','23dba624-31ac-4a4a-867f-6d43e0312d35',2,25,0,NULL,NULL),('255b7bb1-2979-49f8-bb53-c1f83911227d',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','5f9843c5-2bf7-41d5-8fb9-2024f528515a',2,20,1,'3853747a-014f-4c5d-acf9-4a2b06cab57d',NULL),('26f64618-2587-407f-ba5b-0825b1d919f5',NULL,'conditional-user-configured','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','10eac9e9-f236-43f7-aa46-443711c16a86',0,10,0,NULL,NULL),('2c62b4b2-9f03-4500-b17a-057fb9e6f352',NULL,'client-secret','c873670d-8167-4205-af33-8519fdff5955','7e9039f3-defb-4cc0-8b6b-6dc158c1626d',2,10,0,NULL,NULL),('35829ae8-f5c6-4110-a4b9-4b727500baa4',NULL,'registration-page-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','8d5e855d-5619-4fc1-a0cc-8d8167d900ba',0,10,1,'a988487c-3af5-49f0-83f2-5628b0a924c4',NULL),('37422175-fcd2-4bd1-8ca5-462dbae1ce7b',NULL,'organization','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ee4b3315-6404-4ba8-a01c-4632efd2b4db',2,20,0,NULL,NULL),('37e68834-a07c-4230-a33c-9fbe15516fe1',NULL,'registration-page-form','c873670d-8167-4205-af33-8519fdff5955','dd2c82f8-69f7-46b5-8a2f-b57e59e682ba',0,10,1,'ea36d7ff-d640-46bf-a44c-92c460877300',NULL),('38df1360-775f-448c-9212-126616b1ebdc',NULL,'docker-http-basic-authenticator','c873670d-8167-4205-af33-8519fdff5955','afd12a27-1bae-47cb-8978-31ed12fbc2c3',0,10,0,NULL,NULL),('396529ec-4978-49e5-b661-1749e058a8a4',NULL,'conditional-credential','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','2085d5cb-6b96-4e4a-b181-dad2f8e1e87a',0,20,0,NULL,'e324d648-c8fb-41b2-9084-de964e97f7e2'),('3af8848d-b68b-43b3-b9bb-f850d6ae1a15',NULL,'client-jwt','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','6bf32edd-2aa5-437e-a001-eceddcbea9da',2,20,0,NULL,NULL),('430ad599-809f-482d-b6ff-27318f3b92aa',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','3853747a-014f-4c5d-acf9-4a2b06cab57d',0,20,1,'de0b828f-221b-476b-b283-f2c09e6810bc',NULL),('43437652-97b2-4518-a250-d3b7ca68c1f9',NULL,'idp-email-verification','c873670d-8167-4205-af33-8519fdff5955','f423cd14-4220-452e-b57f-0defdeb9bcb1',2,10,0,NULL,NULL),('44234e63-2b35-43c2-a2b8-1da551b05da6',NULL,'conditional-credential','c873670d-8167-4205-af33-8519fdff5955','3d6c607e-801a-41d1-aa35-7684037bd86e',0,20,0,NULL,'3aeb15e5-8062-4628-b941-9a4a5946d250'),('4712a08e-df7a-4dee-b205-9a7c9ef88547',NULL,'direct-grant-validate-password','c873670d-8167-4205-af33-8519fdff5955','f79fe24a-8143-4ffb-a66e-966e12765245',0,20,0,NULL,NULL),('4940e656-000a-4079-9211-ddef34976ef8',NULL,'auth-cookie','c873670d-8167-4205-af33-8519fdff5955','23dba624-31ac-4a4a-867f-6d43e0312d35',2,10,0,NULL,NULL),('4997968b-fe07-408d-93de-318c8e87ecf8',NULL,'reset-password','c873670d-8167-4205-af33-8519fdff5955','40ae2919-d293-41e2-a2db-518bb55c1f8f',0,30,0,NULL,NULL),('4d82c75b-64e9-437b-ba8c-895629b57508',NULL,'idp-username-password-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','d4ddf960-43b9-4971-9adf-b7319ec63a26',0,10,0,NULL,NULL),('4dac849e-ecf1-4b0c-b8ed-4368cdbfa869',NULL,'conditional-credential','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ced49546-0ec2-4913-9e3b-62185ba82c47',0,20,0,NULL,'caf8ccf8-6f0b-4175-93ef-4961e4e4303e'),('4f77c6e1-5b84-4608-9944-41307e977cef',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','f423cd14-4220-452e-b57f-0defdeb9bcb1',2,20,1,'fbdfde99-05b8-4dc3-b489-1353ef3d542c',NULL),('511239b0-d92d-4b5d-8fed-28e0c3614a84',NULL,'auth-recovery-authn-code-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ced49546-0ec2-4913-9e3b-62185ba82c47',3,50,0,NULL,NULL),('51eb796d-160d-48f9-b341-50833a43ab7f',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','824113ab-1df6-4b02-ac91-dbe6ba9a2c7d',1,10,1,'ee4b3315-6404-4ba8-a01c-4632efd2b4db',NULL),('561fcc97-a422-44e6-9495-126af0c63e6f',NULL,'http-basic-authenticator','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f9f0e91f-3167-4a9c-9304-85bcee3a19e6',0,10,0,NULL,NULL),('5693ace4-f975-42ef-be68-81b9cc24c557',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','fbdfde99-05b8-4dc3-b489-1353ef3d542c',1,20,1,'ac6c1ade-7cf1-4185-b085-bb19ad6600a8',NULL),('57093696-e774-49ae-8f6b-05e04f729a19',NULL,'webauthn-authenticator','c873670d-8167-4205-af33-8519fdff5955','3d6c607e-801a-41d1-aa35-7684037bd86e',3,40,0,NULL,NULL),('591915f5-3720-4050-a083-41eac71a838b',NULL,'registration-user-creation','c873670d-8167-4205-af33-8519fdff5955','ea36d7ff-d640-46bf-a44c-92c460877300',0,20,0,NULL,NULL),('5b579cd6-aa36-42d6-83a9-ff69d6a0937c',NULL,'reset-password','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f825ba1c-90e7-4a24-afc6-2d3390a09c99',0,30,0,NULL,NULL),('5c0b19bf-17ce-413f-a73a-e01084ae9360',NULL,'direct-grant-validate-username','c873670d-8167-4205-af33-8519fdff5955','f79fe24a-8143-4ffb-a66e-966e12765245',0,10,0,NULL,NULL),('65c26f67-8e75-4b48-88c5-fea390a59db1',NULL,'auth-username-password-form','c873670d-8167-4205-af33-8519fdff5955','59f1f8db-f561-4d5b-a2fe-59fd5ac72352',0,10,0,NULL,NULL),('69a51de0-9605-49d7-b23a-2257ed8ec11f',NULL,'idp-confirm-link','c873670d-8167-4205-af33-8519fdff5955','929aac20-8f5a-4564-aefc-499b687ba40c',0,10,0,NULL,NULL),('6bb9c9a7-f4bc-407f-9871-3d0048bdb6d2',NULL,'webauthn-authenticator','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','2085d5cb-6b96-4e4a-b181-dad2f8e1e87a',3,40,0,NULL,NULL),('6fad4dd7-568f-4d8f-bdc8-6ab43fbafedc',NULL,'conditional-user-configured','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','2085d5cb-6b96-4e4a-b181-dad2f8e1e87a',0,10,0,NULL,NULL),('710bc18b-2be5-4d3c-83fe-4436a957e476',NULL,'conditional-user-configured','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','6aa5f2fc-e3cf-4343-af2c-6cd11085078c',0,10,0,NULL,NULL),('711782cc-65e9-4df5-a61c-d70c1af1f900',NULL,'conditional-credential','c873670d-8167-4205-af33-8519fdff5955','ac6c1ade-7cf1-4185-b085-bb19ad6600a8',0,20,0,NULL,'2d8939e4-1a2e-4028-aa68-9d5b0bc8a595'),('7501633e-2d7e-4cde-b1fb-37c3a107a24b',NULL,'auth-username-password-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0ac6313f-2df3-4199-8de0-23834861dc55',0,10,0,NULL,NULL),('79dcfed2-4298-4505-8b2c-859c76946d9f',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f825ba1c-90e7-4a24-afc6-2d3390a09c99',1,40,1,'10eac9e9-f236-43f7-aa46-443711c16a86',NULL),('7fb3d04e-de6e-4cbd-8f13-8cbb22aaba8b',NULL,'conditional-user-configured','c873670d-8167-4205-af33-8519fdff5955','3032f6b1-35ce-4dd4-b7a2-0f1ad35134eb',0,10,0,NULL,NULL),('828a5a3e-1f21-4ace-b871-77ec1c645a19',NULL,'auth-recovery-authn-code-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','2085d5cb-6b96-4e4a-b181-dad2f8e1e87a',3,50,0,NULL,NULL),('83179861-897c-43f0-8c67-6781153d82b1',NULL,'conditional-user-configured','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ced49546-0ec2-4913-9e3b-62185ba82c47',0,10,0,NULL,NULL),('8347e2ec-d290-48a6-8dc3-6024d237831b',NULL,'idp-username-password-form','c873670d-8167-4205-af33-8519fdff5955','fbdfde99-05b8-4dc3-b489-1353ef3d542c',0,10,0,NULL,NULL),('8408704c-83d2-492b-9e86-cb7e4b46283c',NULL,'reset-otp','c873670d-8167-4205-af33-8519fdff5955','3032f6b1-35ce-4dd4-b7a2-0f1ad35134eb',0,20,0,NULL,NULL),('855a4965-78eb-4a66-a171-57a037ede314',NULL,'idp-review-profile','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ae22e362-db0c-4a6a-9510-ef529c77ab4f',0,10,0,NULL,'40446b63-da13-4b01-80e9-026e1736227a'),('88f3fdcd-03bf-4a9c-8198-cf771388ac41',NULL,'reset-credentials-choose-user','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f825ba1c-90e7-4a24-afc6-2d3390a09c99',0,10,0,NULL,NULL),('8d25bed7-2f65-44d2-b3ff-543fe8098b06',NULL,'registration-recaptcha-action','c873670d-8167-4205-af33-8519fdff5955','ea36d7ff-d640-46bf-a44c-92c460877300',3,60,0,NULL,NULL),('8d5b14ea-707c-4315-acb7-8a20b936c1c7',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','40ae2919-d293-41e2-a2db-518bb55c1f8f',1,40,1,'3032f6b1-35ce-4dd4-b7a2-0f1ad35134eb',NULL),('8e8dd48b-fede-455d-8193-0270a5905a2d',NULL,'client-x509','c873670d-8167-4205-af33-8519fdff5955','7e9039f3-defb-4cc0-8b6b-6dc158c1626d',2,40,0,NULL,NULL),('8eccab03-8298-4960-957d-2b9865fc7221',NULL,'conditional-user-configured','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ee4b3315-6404-4ba8-a01c-4632efd2b4db',0,10,0,NULL,NULL),('8f239474-319b-488e-b1a3-956b5764b0bb',NULL,'auth-otp-form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','2085d5cb-6b96-4e4a-b181-dad2f8e1e87a',2,30,0,NULL,NULL),('9099723b-3f77-4f3c-a410-5519673428ea',NULL,'conditional-user-configured','c873670d-8167-4205-af33-8519fdff5955','3d6c607e-801a-41d1-aa35-7684037bd86e',0,10,0,NULL,NULL),('91704b04-cb7f-413a-9315-01b7e4db798a',NULL,'client-jwt','c873670d-8167-4205-af33-8519fdff5955','7e9039f3-defb-4cc0-8b6b-6dc158c1626d',2,20,0,NULL,NULL),('95c5fc22-f187-4339-8973-e1214ad3a55c',NULL,'reset-credential-email','c873670d-8167-4205-af33-8519fdff5955','40ae2919-d293-41e2-a2db-518bb55c1f8f',0,20,0,NULL,NULL),('96037665-ba68-485f-b652-66dc77b10311',NULL,'auth-recovery-authn-code-form','c873670d-8167-4205-af33-8519fdff5955','3d6c607e-801a-41d1-aa35-7684037bd86e',3,50,0,NULL,NULL),('96662b37-42e3-408b-8c96-e6e5e02e5448',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','23dba624-31ac-4a4a-867f-6d43e0312d35',2,30,1,'59f1f8db-f561-4d5b-a2fe-59fd5ac72352',NULL),('97f14d55-4676-4ec1-92af-d06184ea748e',NULL,'reset-credential-email','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f825ba1c-90e7-4a24-afc6-2d3390a09c99',0,20,0,NULL,NULL),('9b5b8daf-2b0b-4b9f-9fb7-cacb3ffe819b',NULL,'idp-review-profile','c873670d-8167-4205-af33-8519fdff5955','4e68aab5-fd13-4708-9542-80fde2dbc31b',0,10,0,NULL,'cb857f2e-3308-4803-b273-cf6bd7a547c2'),('9f78fb6b-d86c-4c77-a1d2-fe8599ca9071',NULL,'webauthn-authenticator','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ced49546-0ec2-4913-9e3b-62185ba82c47',3,40,0,NULL,NULL),('9fa63213-fd65-4fee-a0fe-5c1302f3e6a6',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','4e68aab5-fd13-4708-9542-80fde2dbc31b',0,20,1,'d6f8dbdc-38f6-49e7-84d3-31f5aa4121a3',NULL),('a2fc84dc-9ec8-4770-b6ea-273d1c6f5417',NULL,'auth-otp-form','c873670d-8167-4205-af33-8519fdff5955','ac6c1ade-7cf1-4185-b085-bb19ad6600a8',2,30,0,NULL,NULL),('a54320c0-082c-458f-82c6-b0e70721e0d0',NULL,'reset-credentials-choose-user','c873670d-8167-4205-af33-8519fdff5955','40ae2919-d293-41e2-a2db-518bb55c1f8f',0,10,0,NULL,NULL),('a640694e-e7b7-435c-9807-265a8bbf5f4a',NULL,'idp-confirm-link','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','3853747a-014f-4c5d-acf9-4a2b06cab57d',0,10,0,NULL,NULL),('a8b07e05-0419-4d07-8df5-1b54a520c7a2',NULL,'registration-terms-and-conditions','c873670d-8167-4205-af33-8519fdff5955','ea36d7ff-d640-46bf-a44c-92c460877300',3,70,0,NULL,NULL),('ab0b9951-9651-40f8-9e46-645d078622a7',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','46f43257-d304-402a-8cfd-f99957efeaf9',1,30,1,'e83c62e6-5643-45b2-b56e-b24e5782fd40',NULL),('abae2803-66f0-467c-94e7-2e436a94e440',NULL,'conditional-user-configured','c873670d-8167-4205-af33-8519fdff5955','5121548e-4fa5-448a-82f6-d2938a33da60',0,10,0,NULL,NULL),('ac3a24ac-8a77-4f03-bf72-c8c20aec3fc4',NULL,'direct-grant-validate-username','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','46f43257-d304-402a-8cfd-f99957efeaf9',0,10,0,NULL,NULL),('ad91e1d5-a343-4851-90c4-cb12234f3cc3',NULL,'direct-grant-validate-otp','c873670d-8167-4205-af33-8519fdff5955','5121548e-4fa5-448a-82f6-d2938a33da60',0,20,0,NULL,NULL),('ada97840-9ae7-4113-8365-699d594016c5',NULL,'auth-spnego','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','4338d86a-1c34-4feb-8a91-d755c001a5ec',3,20,0,NULL,NULL),('aea9be5e-fd39-405d-85bc-3b5a6ce81c49',NULL,'idp-create-user-if-unique','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','5f9843c5-2bf7-41d5-8fb9-2024f528515a',2,10,0,NULL,'eb95136e-a185-44e9-b92d-5830b24b726e'),('b17e7746-e3fd-4003-a2ac-6d429f4e0d42',NULL,'registration-password-action','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','a988487c-3af5-49f0-83f2-5628b0a924c4',0,50,0,NULL,NULL),('b33cdfea-dae2-462c-8101-d99b7ea73418',NULL,'auth-otp-form','c873670d-8167-4205-af33-8519fdff5955','3d6c607e-801a-41d1-aa35-7684037bd86e',2,30,0,NULL,NULL),('b6fe4539-8ec5-4be2-b464-5e96010bf89d',NULL,'idp-email-verification','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','de0b828f-221b-476b-b283-f2c09e6810bc',2,10,0,NULL,NULL),('b772d8aa-5905-49e0-9e3d-69e2d6752c33',NULL,'direct-grant-validate-password','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','46f43257-d304-402a-8cfd-f99957efeaf9',0,20,0,NULL,NULL),('b8b3f844-88cb-479f-b365-4a484fab5671',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','59f1f8db-f561-4d5b-a2fe-59fd5ac72352',1,20,1,'3d6c607e-801a-41d1-aa35-7684037bd86e',NULL),('bd81d386-e3cf-4a4e-83a8-a17b6da56371',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','d6f8dbdc-38f6-49e7-84d3-31f5aa4121a3',2,20,1,'929aac20-8f5a-4564-aefc-499b687ba40c',NULL),('bf656ca0-8251-4f7a-9acb-ab54a134bc60',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','f79fe24a-8143-4ffb-a66e-966e12765245',1,30,1,'5121548e-4fa5-448a-82f6-d2938a33da60',NULL),('c046c4ed-6266-4193-955c-79a01142c8fe',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ae22e362-db0c-4a6a-9510-ef529c77ab4f',1,60,1,'6aa5f2fc-e3cf-4343-af2c-6cd11085078c',NULL),('ca79873b-82aa-405b-bc27-ff138407fe73',NULL,NULL,'c873670d-8167-4205-af33-8519fdff5955','929aac20-8f5a-4564-aefc-499b687ba40c',0,20,1,'f423cd14-4220-452e-b57f-0defdeb9bcb1',NULL),('cc644bcf-4c41-412b-9496-38f256715c5e',NULL,'reset-otp','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','10eac9e9-f236-43f7-aa46-443711c16a86',0,20,0,NULL,NULL),('cf64dc21-681c-432b-aa2c-935a983099dd',NULL,'registration-password-action','c873670d-8167-4205-af33-8519fdff5955','ea36d7ff-d640-46bf-a44c-92c460877300',0,50,0,NULL,NULL),('cfe20876-1673-4a27-9824-dd577526fe31',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ae22e362-db0c-4a6a-9510-ef529c77ab4f',0,20,1,'5f9843c5-2bf7-41d5-8fb9-2024f528515a',NULL),('d461db3b-e2b8-48c5-afc4-6b4d31f027bf',NULL,'registration-terms-and-conditions','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','a988487c-3af5-49f0-83f2-5628b0a924c4',3,70,0,NULL,NULL),('d7e95ede-10b7-4cbe-af67-0eb12ba2916f',NULL,'auth-recovery-authn-code-form','c873670d-8167-4205-af33-8519fdff5955','ac6c1ade-7cf1-4185-b085-bb19ad6600a8',3,50,0,NULL,NULL),('db729c0a-b832-4476-b531-18812b3405ad',NULL,'http-basic-authenticator','c873670d-8167-4205-af33-8519fdff5955','222a6efb-50fe-4a53-96fd-9e1a672b87ac',0,10,0,NULL,NULL),('e1fffd3f-6e4a-4220-a0d2-fbc8e916620f',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','4338d86a-1c34-4feb-8a91-d755c001a5ec',2,30,1,'0ac6313f-2df3-4199-8de0-23834861dc55',NULL),('e53479d3-f796-47c1-ae41-dfc6b4f113e3',NULL,'registration-user-creation','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','a988487c-3af5-49f0-83f2-5628b0a924c4',0,20,0,NULL,NULL),('efc8d42a-ade5-4a22-a132-7bcce3187251',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','d4ddf960-43b9-4971-9adf-b7319ec63a26',1,20,1,'ced49546-0ec2-4913-9e3b-62185ba82c47',NULL),('f2b3faa1-7ba2-4669-a3d5-5f6903e96b24',NULL,'client-secret','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','6bf32edd-2aa5-437e-a001-eceddcbea9da',2,10,0,NULL,NULL),('f6ba78b9-30da-4ca5-bcb2-58d3f5099334',NULL,'conditional-user-configured','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','e83c62e6-5643-45b2-b56e-b24e5782fd40',0,10,0,NULL,NULL),('f808bfe4-d02c-4c08-8a3c-07a2c322eb8c',NULL,'docker-http-basic-authenticator','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f9a3f1d1-0ac8-4cfc-b084-a7c9fb99d9f2',0,10,0,NULL,NULL),('f97f4f28-8705-4f38-be64-7e40faaa90a4',NULL,NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','4338d86a-1c34-4feb-8a91-d755c001a5ec',2,26,1,'824113ab-1df6-4b02-ac91-dbe6ba9a2c7d',NULL),('faaa03dd-81f0-43bf-b21d-b1d8fa1537e1',NULL,'direct-grant-validate-otp','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','e83c62e6-5643-45b2-b56e-b24e5782fd40',0,20,0,NULL,NULL),('ff1079f0-b15f-4d9c-972e-a6f455b81416',NULL,'client-secret-jwt','c873670d-8167-4205-af33-8519fdff5955','7e9039f3-defb-4cc0-8b6b-6dc158c1626d',2,30,0,NULL,NULL),('fff7bf9e-6aa3-47bd-8426-16fc7fd4ea31',NULL,'client-secret-jwt','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','6bf32edd-2aa5-437e-a001-eceddcbea9da',2,30,0,NULL,NULL);
/*!40000 ALTER TABLE `AUTHENTICATION_EXECUTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATION_FLOW`
--

DROP TABLE IF EXISTS `AUTHENTICATION_FLOW`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATION_FLOW` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'basic-flow',
  `TOP_LEVEL` tinyint NOT NULL DEFAULT '0',
  `BUILT_IN` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IDX_AUTH_FLOW_REALM` (`REALM_ID`),
  CONSTRAINT `FK_AUTH_FLOW_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATION_FLOW`
--

LOCK TABLES `AUTHENTICATION_FLOW` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATION_FLOW` DISABLE KEYS */;
INSERT INTO `AUTHENTICATION_FLOW` (`ID`, `ALIAS`, `DESCRIPTION`, `REALM_ID`, `PROVIDER_ID`, `TOP_LEVEL`, `BUILT_IN`) VALUES ('0ac6313f-2df3-4199-8de0-23834861dc55','forms','Username, password, otp and other auth forms.','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('10eac9e9-f236-43f7-aa46-443711c16a86','Reset - Conditional OTP','Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('2085d5cb-6b96-4e4a-b181-dad2f8e1e87a','Browser - Conditional 2FA','Flow to determine if any 2FA is required for the authentication','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('222a6efb-50fe-4a53-96fd-9e1a672b87ac','saml ecp','SAML ECP Profile Authentication Flow','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('23dba624-31ac-4a4a-867f-6d43e0312d35','browser','Browser based authentication','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('3032f6b1-35ce-4dd4-b7a2-0f1ad35134eb','Reset - Conditional OTP','Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('3853747a-014f-4c5d-acf9-4a2b06cab57d','Handle Existing Account','Handle what to do if there is existing account with same email/username like authenticated identity provider','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('3d6c607e-801a-41d1-aa35-7684037bd86e','Browser - Conditional 2FA','Flow to determine if any 2FA is required for the authentication','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('40ae2919-d293-41e2-a2db-518bb55c1f8f','reset credentials','Reset credentials for a user if they forgot their password or something','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('4338d86a-1c34-4feb-8a91-d755c001a5ec','browser','Browser based authentication','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('46f43257-d304-402a-8cfd-f99957efeaf9','direct grant','OpenID Connect Resource Owner Grant','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('4e68aab5-fd13-4708-9542-80fde2dbc31b','first broker login','Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('5121548e-4fa5-448a-82f6-d2938a33da60','Direct Grant - Conditional OTP','Flow to determine if the OTP is required for the authentication','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('59f1f8db-f561-4d5b-a2fe-59fd5ac72352','forms','Username, password, otp and other auth forms.','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('5f9843c5-2bf7-41d5-8fb9-2024f528515a','User creation or linking','Flow for the existing/non-existing user alternatives','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('6aa5f2fc-e3cf-4343-af2c-6cd11085078c','First Broker Login - Conditional Organization','Flow to determine if the authenticator that adds organization members is to be used','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('6bf32edd-2aa5-437e-a001-eceddcbea9da','clients','Base authentication for clients','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','client-flow',1,1),('7e9039f3-defb-4cc0-8b6b-6dc158c1626d','clients','Base authentication for clients','c873670d-8167-4205-af33-8519fdff5955','client-flow',1,1),('824113ab-1df6-4b02-ac91-dbe6ba9a2c7d','Organization',NULL,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('8d5e855d-5619-4fc1-a0cc-8d8167d900ba','registration','Registration flow','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('929aac20-8f5a-4564-aefc-499b687ba40c','Handle Existing Account','Handle what to do if there is existing account with same email/username like authenticated identity provider','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('a988487c-3af5-49f0-83f2-5628b0a924c4','registration form','Registration form','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','form-flow',0,1),('ac6c1ade-7cf1-4185-b085-bb19ad6600a8','First broker login - Conditional 2FA','Flow to determine if any 2FA is required for the authentication','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('ae22e362-db0c-4a6a-9510-ef529c77ab4f','first broker login','Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('afd12a27-1bae-47cb-8978-31ed12fbc2c3','docker auth','Used by Docker clients to authenticate against the IDP','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('ced49546-0ec2-4913-9e3b-62185ba82c47','First broker login - Conditional 2FA','Flow to determine if any 2FA is required for the authentication','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('d4ddf960-43b9-4971-9adf-b7319ec63a26','Verify Existing Account by Re-authentication','Reauthentication of existing account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('d6f8dbdc-38f6-49e7-84d3-31f5aa4121a3','User creation or linking','Flow for the existing/non-existing user alternatives','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('dd2c82f8-69f7-46b5-8a2f-b57e59e682ba','registration','Registration flow','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('de0b828f-221b-476b-b283-f2c09e6810bc','Account verification options','Method with which to verity the existing account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('e83c62e6-5643-45b2-b56e-b24e5782fd40','Direct Grant - Conditional OTP','Flow to determine if the OTP is required for the authentication','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('ea36d7ff-d640-46bf-a44c-92c460877300','registration form','Registration form','c873670d-8167-4205-af33-8519fdff5955','form-flow',0,1),('ee4b3315-6404-4ba8-a01c-4632efd2b4db','Browser - Conditional Organization','Flow to determine if the organization identity-first login is to be used','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',0,1),('f423cd14-4220-452e-b57f-0defdeb9bcb1','Account verification options','Method with which to verity the existing account','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1),('f79fe24a-8143-4ffb-a66e-966e12765245','direct grant','OpenID Connect Resource Owner Grant','c873670d-8167-4205-af33-8519fdff5955','basic-flow',1,1),('f825ba1c-90e7-4a24-afc6-2d3390a09c99','reset credentials','Reset credentials for a user if they forgot their password or something','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('f9a3f1d1-0ac8-4cfc-b084-a7c9fb99d9f2','docker auth','Used by Docker clients to authenticate against the IDP','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('f9f0e91f-3167-4a9c-9304-85bcee3a19e6','saml ecp','SAML ECP Profile Authentication Flow','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic-flow',1,1),('fbdfde99-05b8-4dc3-b489-1353ef3d542c','Verify Existing Account by Re-authentication','Reauthentication of existing account','c873670d-8167-4205-af33-8519fdff5955','basic-flow',0,1);
/*!40000 ALTER TABLE `AUTHENTICATION_FLOW` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATOR_CONFIG`
--

DROP TABLE IF EXISTS `AUTHENTICATOR_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATOR_CONFIG` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_AUTH_CONFIG_REALM` (`REALM_ID`),
  CONSTRAINT `FK_AUTH_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATOR_CONFIG`
--

LOCK TABLES `AUTHENTICATOR_CONFIG` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG` DISABLE KEYS */;
INSERT INTO `AUTHENTICATOR_CONFIG` (`ID`, `ALIAS`, `REALM_ID`) VALUES ('2d8939e4-1a2e-4028-aa68-9d5b0bc8a595','first-broker-login-conditional-credential','c873670d-8167-4205-af33-8519fdff5955'),('3aeb15e5-8062-4628-b941-9a4a5946d250','browser-conditional-credential','c873670d-8167-4205-af33-8519fdff5955'),('40446b63-da13-4b01-80e9-026e1736227a','review profile config','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc'),('91d0ec7a-49f1-4d17-bcc3-61b334daf63e','create unique user config','c873670d-8167-4205-af33-8519fdff5955'),('caf8ccf8-6f0b-4175-93ef-4961e4e4303e','first-broker-login-conditional-credential','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc'),('cb857f2e-3308-4803-b273-cf6bd7a547c2','review profile config','c873670d-8167-4205-af33-8519fdff5955'),('e324d648-c8fb-41b2-9084-de964e97f7e2','browser-conditional-credential','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc'),('eb95136e-a185-44e9-b92d-5830b24b726e','create unique user config','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc');
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATOR_CONFIG_ENTRY`
--

DROP TABLE IF EXISTS `AUTHENTICATOR_CONFIG_ENTRY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATOR_CONFIG_ENTRY` (
  `AUTHENTICATOR_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`AUTHENTICATOR_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATOR_CONFIG_ENTRY`
--

LOCK TABLES `AUTHENTICATOR_CONFIG_ENTRY` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG_ENTRY` DISABLE KEYS */;
INSERT INTO `AUTHENTICATOR_CONFIG_ENTRY` (`AUTHENTICATOR_ID`, `VALUE`, `NAME`) VALUES ('2d8939e4-1a2e-4028-aa68-9d5b0bc8a595','webauthn-passwordless','credentials'),('3aeb15e5-8062-4628-b941-9a4a5946d250','webauthn-passwordless','credentials'),('40446b63-da13-4b01-80e9-026e1736227a','missing','update.profile.on.first.login'),('91d0ec7a-49f1-4d17-bcc3-61b334daf63e','false','require.password.update.after.registration'),('caf8ccf8-6f0b-4175-93ef-4961e4e4303e','webauthn-passwordless','credentials'),('cb857f2e-3308-4803-b273-cf6bd7a547c2','missing','update.profile.on.first.login'),('e324d648-c8fb-41b2-9084-de964e97f7e2','webauthn-passwordless','credentials'),('eb95136e-a185-44e9-b92d-5830b24b726e','false','require.password.update.after.registration');
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG_ENTRY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BROKER_LINK`
--

DROP TABLE IF EXISTS `BROKER_LINK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BROKER_LINK` (
  `IDENTITY_PROVIDER` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `BROKER_USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BROKER_USERNAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TOKEN` text COLLATE utf8mb4_unicode_ci,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`IDENTITY_PROVIDER`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BROKER_LINK`
--

LOCK TABLES `BROKER_LINK` WRITE;
/*!40000 ALTER TABLE `BROKER_LINK` DISABLE KEYS */;
/*!40000 ALTER TABLE `BROKER_LINK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT`
--

DROP TABLE IF EXISTS `CLIENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ENABLED` tinyint NOT NULL DEFAULT '0',
  `FULL_SCOPE_ALLOWED` tinyint NOT NULL DEFAULT '0',
  `CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NOT_BEFORE` int DEFAULT NULL,
  `PUBLIC_CLIENT` tinyint NOT NULL DEFAULT '0',
  `SECRET` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BASE_URL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BEARER_ONLY` tinyint NOT NULL DEFAULT '0',
  `MANAGEMENT_URL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SURROGATE_AUTH_REQUIRED` tinyint NOT NULL DEFAULT '0',
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROTOCOL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NODE_REREG_TIMEOUT` int DEFAULT '0',
  `FRONTCHANNEL_LOGOUT` tinyint NOT NULL DEFAULT '0',
  `CONSENT_REQUIRED` tinyint NOT NULL DEFAULT '0',
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_ACCOUNTS_ENABLED` tinyint NOT NULL DEFAULT '0',
  `CLIENT_AUTHENTICATOR_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROOT_URL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REGISTRATION_TOKEN` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STANDARD_FLOW_ENABLED` tinyint NOT NULL DEFAULT '1',
  `IMPLICIT_FLOW_ENABLED` tinyint NOT NULL DEFAULT '0',
  `DIRECT_ACCESS_GRANTS_ENABLED` tinyint NOT NULL DEFAULT '0',
  `ALWAYS_DISPLAY_IN_CONSOLE` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_B71CJLBENV945RB6GCON438AT` (`REALM_ID`,`CLIENT_ID`),
  KEY `IDX_CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT`
--

LOCK TABLES `CLIENT` WRITE;
/*!40000 ALTER TABLE `CLIENT` DISABLE KEYS */;
INSERT INTO `CLIENT` (`ID`, `ENABLED`, `FULL_SCOPE_ALLOWED`, `CLIENT_ID`, `NOT_BEFORE`, `PUBLIC_CLIENT`, `SECRET`, `BASE_URL`, `BEARER_ONLY`, `MANAGEMENT_URL`, `SURROGATE_AUTH_REQUIRED`, `REALM_ID`, `PROTOCOL`, `NODE_REREG_TIMEOUT`, `FRONTCHANNEL_LOGOUT`, `CONSENT_REQUIRED`, `NAME`, `SERVICE_ACCOUNTS_ENABLED`, `CLIENT_AUTHENTICATOR_TYPE`, `ROOT_URL`, `DESCRIPTION`, `REGISTRATION_TOKEN`, `STANDARD_FLOW_ENABLED`, `IMPLICIT_FLOW_ENABLED`, `DIRECT_ACCESS_GRANTS_ENABLED`, `ALWAYS_DISPLAY_IN_CONSOLE`) VALUES ('28d5185c-e40e-4d11-a93d-d54349888289',1,0,'master-realm',0,0,NULL,NULL,1,NULL,0,'c873670d-8167-4205-af33-8519fdff5955',NULL,0,0,0,'master Realm',0,'client-secret',NULL,NULL,NULL,1,0,0,0),('3d259113-a339-4887-bc77-5e459cef5e30',1,1,'admin-cli',0,1,NULL,NULL,0,NULL,0,'c873670d-8167-4205-af33-8519fdff5955','openid-connect',0,0,0,'${client_admin-cli}',0,'client-secret',NULL,NULL,NULL,0,0,1,0),('474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,0,'account',0,1,NULL,'/realms/master/account/',0,NULL,0,'c873670d-8167-4205-af33-8519fdff5955','openid-connect',0,0,0,'${client_account}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0),('4a9e15c1-378e-4a7d-a299-5a5a0823034d',1,1,'security-admin-console',0,1,NULL,'/admin/master/console/',0,NULL,0,'c873670d-8167-4205-af33-8519fdff5955','openid-connect',0,0,0,'${client_security-admin-console}',0,'client-secret','${authAdminUrl}',NULL,NULL,1,0,0,0),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3',1,1,'admin-cli',0,1,NULL,NULL,0,NULL,0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',0,0,0,'${client_admin-cli}',0,'client-secret',NULL,NULL,NULL,0,0,1,0),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778',1,1,'security-admin-console',0,1,NULL,'/admin/flighthours/console/',0,NULL,0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',0,0,0,'${client_security-admin-console}',0,'client-secret','${authAdminUrl}',NULL,NULL,1,0,0,0),('7d330af7-4d9b-4abd-bebc-8562527b8d62',1,0,'broker',0,0,NULL,NULL,1,NULL,0,'c873670d-8167-4205-af33-8519fdff5955','openid-connect',0,0,0,'${client_broker}',0,'client-secret',NULL,NULL,NULL,1,0,0,0),('80ea558e-f66c-4b77-bce0-5424629e49bf',1,0,'account',0,1,NULL,'/realms/flighthours/account/',0,NULL,0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',0,0,0,'${client_account}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b',1,1,'emma',0,0,'M9HfWmIWf6huAnpKPXIGNdDeTfrwcNMt','',0,'',0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',-1,1,0,'',0,'client-secret','','',NULL,1,0,1,0),('90feb8c2-3439-42bd-8522-fca2f49fb86b',1,0,'broker',0,0,NULL,NULL,1,NULL,0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',0,0,0,'${client_broker}',0,'client-secret',NULL,NULL,NULL,1,0,0,0),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae',1,0,'account-console',0,1,NULL,'/realms/flighthours/account/',0,NULL,0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',0,0,0,'${client_account-console}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0),('a2ac983e-a7e0-4013-a873-c0abcef7befd',1,0,'flighthours-realm',0,0,NULL,NULL,1,NULL,0,'c873670d-8167-4205-af33-8519fdff5955',NULL,0,0,0,'flighthours Realm',0,'client-secret',NULL,NULL,NULL,1,0,0,0),('abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,0,'realm-management',0,0,NULL,NULL,1,NULL,0,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','openid-connect',0,0,0,'${client_realm-management}',0,'client-secret',NULL,NULL,NULL,1,0,0,0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5',1,0,'account-console',0,1,NULL,'/realms/master/account/',0,NULL,0,'c873670d-8167-4205-af33-8519fdff5955','openid-connect',0,0,0,'${client_account-console}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0);
/*!40000 ALTER TABLE `CLIENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_ATTRIBUTES`
--

DROP TABLE IF EXISTS `CLIENT_ATTRIBUTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_ATTRIBUTES` (
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`CLIENT_ID`,`NAME`),
  KEY `IDX_CLIENT_ATT_BY_NAME_VALUE` (`NAME`,`VALUE`(255)),
  CONSTRAINT `FK3C47C64BEACCA966` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_ATTRIBUTES`
--

LOCK TABLES `CLIENT_ATTRIBUTES` WRITE;
/*!40000 ALTER TABLE `CLIENT_ATTRIBUTES` DISABLE KEYS */;
INSERT INTO `CLIENT_ATTRIBUTES` (`CLIENT_ID`, `NAME`, `VALUE`) VALUES ('3d259113-a339-4887-bc77-5e459cef5e30','client.use.lightweight.access.token.enabled','true'),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','post.logout.redirect.uris','+'),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','client.use.lightweight.access.token.enabled','true'),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','pkce.code.challenge.method','S256'),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','post.logout.redirect.uris','+'),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','client.use.lightweight.access.token.enabled','true'),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','client.use.lightweight.access.token.enabled','true'),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','pkce.code.challenge.method','S256'),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','post.logout.redirect.uris','+'),('80ea558e-f66c-4b77-bce0-5424629e49bf','post.logout.redirect.uris','+'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','backchannel.logout.revoke.offline.tokens','false'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','backchannel.logout.session.required','true'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','display.on.consent.screen','false'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','dpop.bound.access.tokens','false'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','frontchannel.logout.session.required','true'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','oauth2.device.authorization.grant.enabled','false'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','oidc.ciba.grant.enabled','false'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','realm_client','false'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','standard.token.exchange.enabled','false'),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','pkce.code.challenge.method','S256'),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','post.logout.redirect.uris','+'),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','pkce.code.challenge.method','S256'),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','post.logout.redirect.uris','+');
/*!40000 ALTER TABLE `CLIENT_ATTRIBUTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_AUTH_FLOW_BINDINGS`
--

DROP TABLE IF EXISTS `CLIENT_AUTH_FLOW_BINDINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_AUTH_FLOW_BINDINGS` (
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FLOW_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BINDING_NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`BINDING_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_AUTH_FLOW_BINDINGS`
--

LOCK TABLES `CLIENT_AUTH_FLOW_BINDINGS` WRITE;
/*!40000 ALTER TABLE `CLIENT_AUTH_FLOW_BINDINGS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_AUTH_FLOW_BINDINGS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_INITIAL_ACCESS`
--

DROP TABLE IF EXISTS `CLIENT_INITIAL_ACCESS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_INITIAL_ACCESS` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TIMESTAMP` int DEFAULT NULL,
  `EXPIRATION` int DEFAULT NULL,
  `COUNT` int DEFAULT NULL,
  `REMAINING_COUNT` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_CLIENT_INIT_ACC_REALM` (`REALM_ID`),
  CONSTRAINT `FK_CLIENT_INIT_ACC_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_INITIAL_ACCESS`
--

LOCK TABLES `CLIENT_INITIAL_ACCESS` WRITE;
/*!40000 ALTER TABLE `CLIENT_INITIAL_ACCESS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_INITIAL_ACCESS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_NODE_REGISTRATIONS`
--

DROP TABLE IF EXISTS `CLIENT_NODE_REGISTRATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_NODE_REGISTRATIONS` (
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` int DEFAULT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`NAME`),
  CONSTRAINT `FK4129723BA992F594` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_NODE_REGISTRATIONS`
--

LOCK TABLES `CLIENT_NODE_REGISTRATIONS` WRITE;
/*!40000 ALTER TABLE `CLIENT_NODE_REGISTRATIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_NODE_REGISTRATIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROTOCOL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_CLI_SCOPE` (`REALM_ID`,`NAME`),
  KEY `IDX_REALM_CLSCOPE` (`REALM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE`
--

LOCK TABLES `CLIENT_SCOPE` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE` (`ID`, `NAME`, `REALM_ID`, `DESCRIPTION`, `PROTOCOL`) VALUES ('0dce6a7b-00e3-46f7-91ce-0ebab2c4cb40','role_list','c873670d-8167-4205-af33-8519fdff5955','SAML role list','saml'),('1525a54b-4819-4ec1-b7a5-a4fd59b46a87','address','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect built-in scope: address','openid-connect'),('18acd87e-defa-442c-9f22-17de31d3e6c6','acr','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect scope for add acr (authentication context class reference) to the token','openid-connect'),('1bbf5f24-4928-462e-b7e8-3aaef5c451d0','service_account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','Specific scope for a client enabled for service accounts','openid-connect'),('21f57746-bd06-4754-98dc-5d5644197a1c','organization','c873670d-8167-4205-af33-8519fdff5955','Additional claims about the organization a subject belongs to','openid-connect'),('229b3874-96b9-4b24-86be-1c77178fecbf','roles','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect scope for add user roles to the access token','openid-connect'),('28384917-02ed-4cff-b623-7b07312e6957','address','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect built-in scope: address','openid-connect'),('2a71c4c4-6670-4109-a418-7cad37eae11f','saml_organization','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','Organization Membership','saml'),('41e52320-5f02-405b-b573-57e05efff200','offline_access','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect built-in scope: offline_access','openid-connect'),('492a67dc-ab1a-411b-8aff-5a1e8f4c9153','saml_organization','c873670d-8167-4205-af33-8519fdff5955','Organization Membership','saml'),('4a4f1740-3ff8-4d0a-b393-a080cfe5eab6','role_list','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','SAML role list','saml'),('5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8','roles','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect scope for add user roles to the access token','openid-connect'),('6b58bdf3-ba9e-4138-98cc-2adfe96a84b1','profile','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect built-in scope: profile','openid-connect'),('74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50','email','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect built-in scope: email','openid-connect'),('93895050-1420-4db0-89cf-1646b1c24662','offline_access','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect built-in scope: offline_access','openid-connect'),('a743a1b7-0c2a-4574-9cea-705a924a771b','phone','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect built-in scope: phone','openid-connect'),('a9c6cbeb-1e10-475c-a89e-3ba7c669468f','profile','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect built-in scope: profile','openid-connect'),('b0db2e23-0e7d-4738-bbd2-c3df4d2325f0','microprofile-jwt','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','Microprofile - JWT built-in scope','openid-connect'),('b108748b-23a0-430a-9921-c1f1fcbe3548','email','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect built-in scope: email','openid-connect'),('cf90ce90-377b-426c-bd98-b92acd4e85f3','microprofile-jwt','c873670d-8167-4205-af33-8519fdff5955','Microprofile - JWT built-in scope','openid-connect'),('d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab','phone','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect built-in scope: phone','openid-connect'),('e541d53a-0702-4352-a8db-1f21c3f32577','basic','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect scope for add all basic claims to the token','openid-connect'),('e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e','acr','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect scope for add acr (authentication context class reference) to the token','openid-connect'),('e9aa4630-2911-4e04-bc19-b3bcf1a6083a','web-origins','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect scope for add allowed web origins to the access token','openid-connect'),('eab91a8c-7bf3-4217-8a44-28fa150ec6ab','basic','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','OpenID Connect scope for add all basic claims to the token','openid-connect'),('ebd52604-b8ba-453e-9421-875b746626dc','service_account','c873670d-8167-4205-af33-8519fdff5955','Specific scope for a client enabled for service accounts','openid-connect'),('ef0b0964-0624-4733-8b8e-688a1db399db','web-origins','c873670d-8167-4205-af33-8519fdff5955','OpenID Connect scope for add allowed web origins to the access token','openid-connect'),('f03c0dde-12e1-4771-a74e-6f6515c2ecf3','organization','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','Additional claims about the organization a subject belongs to','openid-connect');
/*!40000 ALTER TABLE `CLIENT_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE_ATTRIBUTES`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE_ATTRIBUTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE_ATTRIBUTES` (
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` text COLLATE utf8mb4_unicode_ci,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCOPE_ID`,`NAME`),
  KEY `IDX_CLSCOPE_ATTRS` (`SCOPE_ID`),
  CONSTRAINT `FK_CL_SCOPE_ATTR_SCOPE` FOREIGN KEY (`SCOPE_ID`) REFERENCES `CLIENT_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE_ATTRIBUTES`
--

LOCK TABLES `CLIENT_SCOPE_ATTRIBUTES` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE_ATTRIBUTES` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE_ATTRIBUTES` (`SCOPE_ID`, `VALUE`, `NAME`) VALUES ('0dce6a7b-00e3-46f7-91ce-0ebab2c4cb40','${samlRoleListScopeConsentText}','consent.screen.text'),('0dce6a7b-00e3-46f7-91ce-0ebab2c4cb40','true','display.on.consent.screen'),('1525a54b-4819-4ec1-b7a5-a4fd59b46a87','${addressScopeConsentText}','consent.screen.text'),('1525a54b-4819-4ec1-b7a5-a4fd59b46a87','true','display.on.consent.screen'),('1525a54b-4819-4ec1-b7a5-a4fd59b46a87','true','include.in.token.scope'),('18acd87e-defa-442c-9f22-17de31d3e6c6','false','display.on.consent.screen'),('18acd87e-defa-442c-9f22-17de31d3e6c6','false','include.in.token.scope'),('1bbf5f24-4928-462e-b7e8-3aaef5c451d0','false','display.on.consent.screen'),('1bbf5f24-4928-462e-b7e8-3aaef5c451d0','false','include.in.token.scope'),('21f57746-bd06-4754-98dc-5d5644197a1c','${organizationScopeConsentText}','consent.screen.text'),('21f57746-bd06-4754-98dc-5d5644197a1c','true','display.on.consent.screen'),('21f57746-bd06-4754-98dc-5d5644197a1c','true','include.in.token.scope'),('229b3874-96b9-4b24-86be-1c77178fecbf','${rolesScopeConsentText}','consent.screen.text'),('229b3874-96b9-4b24-86be-1c77178fecbf','true','display.on.consent.screen'),('229b3874-96b9-4b24-86be-1c77178fecbf','false','include.in.token.scope'),('28384917-02ed-4cff-b623-7b07312e6957','${addressScopeConsentText}','consent.screen.text'),('28384917-02ed-4cff-b623-7b07312e6957','true','display.on.consent.screen'),('28384917-02ed-4cff-b623-7b07312e6957','true','include.in.token.scope'),('2a71c4c4-6670-4109-a418-7cad37eae11f','false','display.on.consent.screen'),('41e52320-5f02-405b-b573-57e05efff200','${offlineAccessScopeConsentText}','consent.screen.text'),('41e52320-5f02-405b-b573-57e05efff200','true','display.on.consent.screen'),('492a67dc-ab1a-411b-8aff-5a1e8f4c9153','false','display.on.consent.screen'),('4a4f1740-3ff8-4d0a-b393-a080cfe5eab6','${samlRoleListScopeConsentText}','consent.screen.text'),('4a4f1740-3ff8-4d0a-b393-a080cfe5eab6','true','display.on.consent.screen'),('5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8','${rolesScopeConsentText}','consent.screen.text'),('5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8','true','display.on.consent.screen'),('5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8','false','include.in.token.scope'),('6b58bdf3-ba9e-4138-98cc-2adfe96a84b1','${profileScopeConsentText}','consent.screen.text'),('6b58bdf3-ba9e-4138-98cc-2adfe96a84b1','true','display.on.consent.screen'),('6b58bdf3-ba9e-4138-98cc-2adfe96a84b1','true','include.in.token.scope'),('74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50','${emailScopeConsentText}','consent.screen.text'),('74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50','true','display.on.consent.screen'),('74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50','true','include.in.token.scope'),('93895050-1420-4db0-89cf-1646b1c24662','${offlineAccessScopeConsentText}','consent.screen.text'),('93895050-1420-4db0-89cf-1646b1c24662','true','display.on.consent.screen'),('a743a1b7-0c2a-4574-9cea-705a924a771b','${phoneScopeConsentText}','consent.screen.text'),('a743a1b7-0c2a-4574-9cea-705a924a771b','true','display.on.consent.screen'),('a743a1b7-0c2a-4574-9cea-705a924a771b','true','include.in.token.scope'),('a9c6cbeb-1e10-475c-a89e-3ba7c669468f','${profileScopeConsentText}','consent.screen.text'),('a9c6cbeb-1e10-475c-a89e-3ba7c669468f','true','display.on.consent.screen'),('a9c6cbeb-1e10-475c-a89e-3ba7c669468f','true','include.in.token.scope'),('b0db2e23-0e7d-4738-bbd2-c3df4d2325f0','false','display.on.consent.screen'),('b0db2e23-0e7d-4738-bbd2-c3df4d2325f0','true','include.in.token.scope'),('b108748b-23a0-430a-9921-c1f1fcbe3548','${emailScopeConsentText}','consent.screen.text'),('b108748b-23a0-430a-9921-c1f1fcbe3548','true','display.on.consent.screen'),('b108748b-23a0-430a-9921-c1f1fcbe3548','true','include.in.token.scope'),('cf90ce90-377b-426c-bd98-b92acd4e85f3','false','display.on.consent.screen'),('cf90ce90-377b-426c-bd98-b92acd4e85f3','true','include.in.token.scope'),('d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab','${phoneScopeConsentText}','consent.screen.text'),('d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab','true','display.on.consent.screen'),('d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab','true','include.in.token.scope'),('e541d53a-0702-4352-a8db-1f21c3f32577','false','display.on.consent.screen'),('e541d53a-0702-4352-a8db-1f21c3f32577','false','include.in.token.scope'),('e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e','false','display.on.consent.screen'),('e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e','false','include.in.token.scope'),('e9aa4630-2911-4e04-bc19-b3bcf1a6083a','','consent.screen.text'),('e9aa4630-2911-4e04-bc19-b3bcf1a6083a','false','display.on.consent.screen'),('e9aa4630-2911-4e04-bc19-b3bcf1a6083a','false','include.in.token.scope'),('eab91a8c-7bf3-4217-8a44-28fa150ec6ab','false','display.on.consent.screen'),('eab91a8c-7bf3-4217-8a44-28fa150ec6ab','false','include.in.token.scope'),('ebd52604-b8ba-453e-9421-875b746626dc','false','display.on.consent.screen'),('ebd52604-b8ba-453e-9421-875b746626dc','false','include.in.token.scope'),('ef0b0964-0624-4733-8b8e-688a1db399db','','consent.screen.text'),('ef0b0964-0624-4733-8b8e-688a1db399db','false','display.on.consent.screen'),('ef0b0964-0624-4733-8b8e-688a1db399db','false','include.in.token.scope'),('f03c0dde-12e1-4771-a74e-6f6515c2ecf3','${organizationScopeConsentText}','consent.screen.text'),('f03c0dde-12e1-4771-a74e-6f6515c2ecf3','true','display.on.consent.screen'),('f03c0dde-12e1-4771-a74e-6f6515c2ecf3','true','include.in.token.scope');
/*!40000 ALTER TABLE `CLIENT_SCOPE_ATTRIBUTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE_CLIENT`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE_CLIENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE_CLIENT` (
  `CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SCOPE_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DEFAULT_SCOPE` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`CLIENT_ID`,`SCOPE_ID`),
  KEY `IDX_CLSCOPE_CL` (`CLIENT_ID`),
  KEY `IDX_CL_CLSCOPE` (`SCOPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE_CLIENT`
--

LOCK TABLES `CLIENT_SCOPE_CLIENT` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE_CLIENT` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE_CLIENT` (`CLIENT_ID`, `SCOPE_ID`, `DEFAULT_SCOPE`) VALUES ('28d5185c-e40e-4d11-a93d-d54349888289','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('28d5185c-e40e-4d11-a93d-d54349888289','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('28d5185c-e40e-4d11-a93d-d54349888289','21f57746-bd06-4754-98dc-5d5644197a1c',0),('28d5185c-e40e-4d11-a93d-d54349888289','229b3874-96b9-4b24-86be-1c77178fecbf',1),('28d5185c-e40e-4d11-a93d-d54349888289','41e52320-5f02-405b-b573-57e05efff200',0),('28d5185c-e40e-4d11-a93d-d54349888289','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('28d5185c-e40e-4d11-a93d-d54349888289','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('28d5185c-e40e-4d11-a93d-d54349888289','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('28d5185c-e40e-4d11-a93d-d54349888289','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('28d5185c-e40e-4d11-a93d-d54349888289','e541d53a-0702-4352-a8db-1f21c3f32577',1),('28d5185c-e40e-4d11-a93d-d54349888289','ef0b0964-0624-4733-8b8e-688a1db399db',1),('3d259113-a339-4887-bc77-5e459cef5e30','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('3d259113-a339-4887-bc77-5e459cef5e30','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('3d259113-a339-4887-bc77-5e459cef5e30','21f57746-bd06-4754-98dc-5d5644197a1c',0),('3d259113-a339-4887-bc77-5e459cef5e30','229b3874-96b9-4b24-86be-1c77178fecbf',1),('3d259113-a339-4887-bc77-5e459cef5e30','41e52320-5f02-405b-b573-57e05efff200',0),('3d259113-a339-4887-bc77-5e459cef5e30','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('3d259113-a339-4887-bc77-5e459cef5e30','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('3d259113-a339-4887-bc77-5e459cef5e30','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('3d259113-a339-4887-bc77-5e459cef5e30','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('3d259113-a339-4887-bc77-5e459cef5e30','e541d53a-0702-4352-a8db-1f21c3f32577',1),('3d259113-a339-4887-bc77-5e459cef5e30','ef0b0964-0624-4733-8b8e-688a1db399db',1),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','21f57746-bd06-4754-98dc-5d5644197a1c',0),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','229b3874-96b9-4b24-86be-1c77178fecbf',1),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','41e52320-5f02-405b-b573-57e05efff200',0),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','e541d53a-0702-4352-a8db-1f21c3f32577',1),('474ae4f8-f457-4bdc-8188-f31b5c2da25d','ef0b0964-0624-4733-8b8e-688a1db399db',1),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','21f57746-bd06-4754-98dc-5d5644197a1c',0),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','229b3874-96b9-4b24-86be-1c77178fecbf',1),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','41e52320-5f02-405b-b573-57e05efff200',0),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','e541d53a-0702-4352-a8db-1f21c3f32577',1),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','ef0b0964-0624-4733-8b8e-688a1db399db',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','28384917-02ed-4cff-b623-7b07312e6957',0),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','93895050-1420-4db0-89cf-1646b1c24662',0),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('4fdac1f0-5e24-47cb-91a8-1be2b594eec3','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','28384917-02ed-4cff-b623-7b07312e6957',0),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','93895050-1420-4db0-89cf-1646b1c24662',0),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('7d330af7-4d9b-4abd-bebc-8562527b8d62','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('7d330af7-4d9b-4abd-bebc-8562527b8d62','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('7d330af7-4d9b-4abd-bebc-8562527b8d62','21f57746-bd06-4754-98dc-5d5644197a1c',0),('7d330af7-4d9b-4abd-bebc-8562527b8d62','229b3874-96b9-4b24-86be-1c77178fecbf',1),('7d330af7-4d9b-4abd-bebc-8562527b8d62','41e52320-5f02-405b-b573-57e05efff200',0),('7d330af7-4d9b-4abd-bebc-8562527b8d62','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('7d330af7-4d9b-4abd-bebc-8562527b8d62','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('7d330af7-4d9b-4abd-bebc-8562527b8d62','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('7d330af7-4d9b-4abd-bebc-8562527b8d62','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('7d330af7-4d9b-4abd-bebc-8562527b8d62','e541d53a-0702-4352-a8db-1f21c3f32577',1),('7d330af7-4d9b-4abd-bebc-8562527b8d62','ef0b0964-0624-4733-8b8e-688a1db399db',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','28384917-02ed-4cff-b623-7b07312e6957',0),('80ea558e-f66c-4b77-bce0-5424629e49bf','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','93895050-1420-4db0-89cf-1646b1c24662',0),('80ea558e-f66c-4b77-bce0-5424629e49bf','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('80ea558e-f66c-4b77-bce0-5424629e49bf','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('80ea558e-f66c-4b77-bce0-5424629e49bf','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('80ea558e-f66c-4b77-bce0-5424629e49bf','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','28384917-02ed-4cff-b623-7b07312e6957',0),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','93895050-1420-4db0-89cf-1646b1c24662',0),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('90feb8c2-3439-42bd-8522-fca2f49fb86b','28384917-02ed-4cff-b623-7b07312e6957',0),('90feb8c2-3439-42bd-8522-fca2f49fb86b','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('90feb8c2-3439-42bd-8522-fca2f49fb86b','93895050-1420-4db0-89cf-1646b1c24662',0),('90feb8c2-3439-42bd-8522-fca2f49fb86b','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('90feb8c2-3439-42bd-8522-fca2f49fb86b','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('90feb8c2-3439-42bd-8522-fca2f49fb86b','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('90feb8c2-3439-42bd-8522-fca2f49fb86b','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('90feb8c2-3439-42bd-8522-fca2f49fb86b','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('90feb8c2-3439-42bd-8522-fca2f49fb86b','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('90feb8c2-3439-42bd-8522-fca2f49fb86b','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('90feb8c2-3439-42bd-8522-fca2f49fb86b','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','28384917-02ed-4cff-b623-7b07312e6957',0),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','93895050-1420-4db0-89cf-1646b1c24662',0),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','28384917-02ed-4cff-b623-7b07312e6957',0),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','93895050-1420-4db0-89cf-1646b1c24662',0),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('abb55dcc-23ed-448b-8265-bcb91d09c1d3','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','21f57746-bd06-4754-98dc-5d5644197a1c',0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','229b3874-96b9-4b24-86be-1c77178fecbf',1),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','41e52320-5f02-405b-b573-57e05efff200',0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','e541d53a-0702-4352-a8db-1f21c3f32577',1),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','ef0b0964-0624-4733-8b8e-688a1db399db',1);
/*!40000 ALTER TABLE `CLIENT_SCOPE_CLIENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE_ROLE_MAPPING` (
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ROLE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCOPE_ID`,`ROLE_ID`),
  KEY `IDX_CLSCOPE_ROLE` (`SCOPE_ID`),
  KEY `IDX_ROLE_CLSCOPE` (`ROLE_ID`),
  CONSTRAINT `FK_CL_SCOPE_RM_SCOPE` FOREIGN KEY (`SCOPE_ID`) REFERENCES `CLIENT_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE_ROLE_MAPPING`
--

LOCK TABLES `CLIENT_SCOPE_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE_ROLE_MAPPING` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE_ROLE_MAPPING` (`SCOPE_ID`, `ROLE_ID`) VALUES ('41e52320-5f02-405b-b573-57e05efff200','7d02219a-ef97-4500-9c3e-ee6de52bf465'),('93895050-1420-4db0-89cf-1646b1c24662','61d078d4-1e5c-4326-978c-295428d41c62');
/*!40000 ALTER TABLE `CLIENT_SCOPE_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMPONENT`
--

DROP TABLE IF EXISTS `COMPONENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMPONENT` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PARENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROVIDER_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SUB_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_COMPONENT_REALM` (`REALM_ID`),
  KEY `IDX_COMPONENT_PROVIDER_TYPE` (`PROVIDER_TYPE`),
  CONSTRAINT `FK_COMPONENT_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPONENT`
--

LOCK TABLES `COMPONENT` WRITE;
/*!40000 ALTER TABLE `COMPONENT` DISABLE KEYS */;
INSERT INTO `COMPONENT` (`ID`, `NAME`, `PARENT_ID`, `PROVIDER_ID`, `PROVIDER_TYPE`, `REALM_ID`, `SUB_TYPE`) VALUES ('0d7190e4-d287-4c96-8ffe-1a4186577c31','aes-generated','c873670d-8167-4205-af33-8519fdff5955','aes-generated','org.keycloak.keys.KeyProvider','c873670d-8167-4205-af33-8519fdff5955',NULL),('1afa532a-20cc-4a30-bc89-5a5c0ac43ccc','Max Clients Limit','c873670d-8167-4205-af33-8519fdff5955','max-clients','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','anonymous'),('21682e8c-aa3a-4aea-b022-5b5f919e30b7','rsa-enc-generated','c873670d-8167-4205-af33-8519fdff5955','rsa-enc-generated','org.keycloak.keys.KeyProvider','c873670d-8167-4205-af33-8519fdff5955',NULL),('21c668c0-041f-44fd-852d-82974d700db6','hmac-generated-hs512','c873670d-8167-4205-af33-8519fdff5955','hmac-generated','org.keycloak.keys.KeyProvider','c873670d-8167-4205-af33-8519fdff5955',NULL),('2e375d98-c3de-4e92-9b6c-4937cdf1f103','aes-generated','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','aes-generated','org.keycloak.keys.KeyProvider','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL),('34bc7a33-2907-44d0-8336-c462b8b3b846','Full Scope Disabled','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','scope','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','anonymous'),('39c1f564-bc07-4d04-b409-0b676ea29509','rsa-enc-generated','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','rsa-enc-generated','org.keycloak.keys.KeyProvider','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL),('55f6a270-95cc-4c14-89de-bb3760e82aaa','Allowed Client Scopes','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','anonymous'),('5b1bcdfa-0fd8-4576-8af9-d0b709497e2c','rsa-generated','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','rsa-generated','org.keycloak.keys.KeyProvider','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL),('5f3a13d6-3c42-4bd1-9a27-faf6943a196f','Allowed Protocol Mapper Types','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','authenticated'),('63244a9c-7340-4d3d-b4e4-587479b806bf','Allowed Client Scopes','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','authenticated'),('7a6d3342-be01-44c5-884c-4c7af2304ef0',NULL,'c873670d-8167-4205-af33-8519fdff5955','declarative-user-profile','org.keycloak.userprofile.UserProfileProvider','c873670d-8167-4205-af33-8519fdff5955',NULL),('7fdc759a-b724-41f9-ba19-fee95123326e','Allowed Client Scopes','c873670d-8167-4205-af33-8519fdff5955','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','anonymous'),('89998d0a-2d7f-4dd1-a97f-44603e805091','Trusted Hosts','c873670d-8167-4205-af33-8519fdff5955','trusted-hosts','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','anonymous'),('9b769ff5-f71a-4ce0-8c55-3801d221d238','hmac-generated-hs512','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','hmac-generated','org.keycloak.keys.KeyProvider','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL),('a5d2e1be-d39e-4d34-a35b-cb7705606521','Allowed Protocol Mapper Types','c873670d-8167-4205-af33-8519fdff5955','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','anonymous'),('aeb6017f-32f8-4999-90fa-f9b68d884201','Max Clients Limit','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','max-clients','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','anonymous'),('bff8f19f-4e3b-40b6-b977-daf01bb3d0d6','Consent Required','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','consent-required','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','anonymous'),('d4247186-8801-4626-b620-00d1c03dbb2c','Trusted Hosts','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','trusted-hosts','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','anonymous'),('da554b40-b8de-442c-a89e-4cedf18faea3','rsa-generated','c873670d-8167-4205-af33-8519fdff5955','rsa-generated','org.keycloak.keys.KeyProvider','c873670d-8167-4205-af33-8519fdff5955',NULL),('dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','Allowed Protocol Mapper Types','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','anonymous'),('e3181704-068f-4b85-a994-99a58ea87859','Consent Required','c873670d-8167-4205-af33-8519fdff5955','consent-required','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','anonymous'),('e7d9cdda-6b96-4518-b49f-44db5ac4ac03','Full Scope Disabled','c873670d-8167-4205-af33-8519fdff5955','scope','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','anonymous'),('eefe6a53-a342-4790-a16b-4e511f784780','Allowed Client Scopes','c873670d-8167-4205-af33-8519fdff5955','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','authenticated'),('fe3ef56c-150c-43c0-ae2c-d4408b4199c8','Allowed Protocol Mapper Types','c873670d-8167-4205-af33-8519fdff5955','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c873670d-8167-4205-af33-8519fdff5955','authenticated');
/*!40000 ALTER TABLE `COMPONENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMPONENT_CONFIG`
--

DROP TABLE IF EXISTS `COMPONENT_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMPONENT_CONFIG` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `COMPONENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`ID`),
  KEY `IDX_COMPO_CONFIG_COMPO` (`COMPONENT_ID`),
  CONSTRAINT `FK_COMPONENT_CONFIG` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPONENT_CONFIG`
--

LOCK TABLES `COMPONENT_CONFIG` WRITE;
/*!40000 ALTER TABLE `COMPONENT_CONFIG` DISABLE KEYS */;
INSERT INTO `COMPONENT_CONFIG` (`ID`, `COMPONENT_ID`, `NAME`, `VALUE`) VALUES ('02baa416-c727-4752-8255-961b440dc414','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('0624b7c3-9bc3-4d59-9aa0-70c593f73ff1','9b769ff5-f71a-4ce0-8c55-3801d221d238','kid','80a3691e-7cc8-4e01-a4f9-d3a7347c417a'),('07ae3960-72dd-4317-939a-99f892289e91','21c668c0-041f-44fd-852d-82974d700db6','algorithm','HS512'),('08f81a15-95bb-4755-8bec-62125506a1ec','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','saml-user-property-mapper'),('0a95629b-5f74-4b6b-b8ac-8049fc5a098e','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('0f6194d0-5157-4b8f-a072-9f2136d86d88','9b769ff5-f71a-4ce0-8c55-3801d221d238','priority','100'),('10d8c96e-178e-4373-b3ec-7524e9a7e7c2','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','saml-role-list-mapper'),('12af6868-27f7-4a6c-8b62-4ea5f49ea6a5','21682e8c-aa3a-4aea-b022-5b5f919e30b7','priority','100'),('144681c3-5df2-4b21-b461-c87295225330','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','oidc-full-name-mapper'),('14abb4e1-1ae5-4f91-b0f0-30f8124be9da','aeb6017f-32f8-4999-90fa-f9b68d884201','max-clients','200'),('155e0848-65ae-4e53-977f-35527596ec49','21682e8c-aa3a-4aea-b022-5b5f919e30b7','keyUse','ENC'),('1636ea0e-bc88-4959-b2d6-dcbdc33a3239','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('1848bb2d-b166-4b34-adfd-1a3d8c5d48a2','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','oidc-full-name-mapper'),('198ee822-53a6-4eb2-8011-93e3be0e8f91','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('1f35caf3-8884-43b2-bd18-e46be1ca4b8a','0d7190e4-d287-4c96-8ffe-1a4186577c31','priority','100'),('25acc4d4-6d53-4798-affa-75d6d771d7e7','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('2ce1d7e9-8732-46f4-a554-ee0f77ad4c5d','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('3113a84e-3f55-4676-a927-92ca284165b2','d4247186-8801-4626-b620-00d1c03dbb2c','client-uris-must-match','true'),('39f72053-eb5b-4a23-8790-9c57c4068069','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('3a223a75-bbef-4319-b191-983390688219','9b769ff5-f71a-4ce0-8c55-3801d221d238','secret','tZQwDb-VUjW9hPtMlys1nN-KL7q1YJzlIdwq-mk__6IV88637Cfn8g03PDw0k3E8_GWkN72hCSz5ju9I-pz0VtEjqPjgpuA1hF17LSOpuevA-MdC2yprfWGA6pwgb6nCIixvXBKQCuvWUO7636DA8K_CNXnzyZwnqUya8sYEFOk'),('3e1351c4-ead1-40f6-ab53-b99733b51312','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('416ee59d-7d8b-43cf-9cda-454c0c86baab','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('470bea08-0726-4b03-815b-694370169890','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('4e5367af-32cb-4d23-9323-5d86bd83995d','39c1f564-bc07-4d04-b409-0b676ea29509','algorithm','RSA-OAEP'),('4e5b6fc8-4c4a-4c0f-8163-a2f84a57919b','da554b40-b8de-442c-a89e-4cedf18faea3','keyUse','SIG'),('571e2e6b-7190-4521-a6e3-f9e692c4db45','21c668c0-041f-44fd-852d-82974d700db6','secret','dJV5It0Ji_strE0RscmZcy5zqulHNm3mVaYwYc7fv7dihGIbVTgTsgrw6Swd39FkUjoXCg38_RHHKanGEfT4PwlYBpSM_Mb7WOAInM1ZgpnfwppXklDBazvkq_Nr2xuON3s4i0IWWINm6GA2jdo1dtaMOOkwGF7VnwVKBmp4XlI'),('59fe88aa-7f10-403a-8b51-cdd8e022daac','7fdc759a-b724-41f9-ba19-fee95123326e','allow-default-scopes','true'),('5cfc1e5c-8913-4e70-ace7-22435a96a52f','0d7190e4-d287-4c96-8ffe-1a4186577c31','kid','d624e747-fa3c-49b7-944e-e60c6a9f4e39'),('63bf1630-fd12-4a7c-8043-e6ddcf6855be','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','saml-user-property-mapper'),('7009781d-8599-42da-b318-e3768f997bed','5b1bcdfa-0fd8-4576-8af9-d0b709497e2c','privateKey','MIIEowIBAAKCAQEAoxHQ3bQQRsk/gKxXxqy16IhG3i42xzA2H4gJPsXt3Hb0CncuthI2Whk4nkmyUBRWRtAsvbeUD7uFWamqiHz2p7hxOz/gJbckEG80ksoFdlh0HVbl6LeXN6RaALdSeNZxY+jyewJT73Jf3bxsQ0zuqyOkmn2JxiEmEU6LWocogwHxosepde1hqIGZeFBOLfTX4RIyeGaCQrbgO7KPsBlnKOs0Kvmn7ZurDyxk86JcY57UwJhYvBfgNmxst4V8CCK7j5QWORWcscFFlDhIwNc88QKE0OiTgMM3J3qT0BQe+/RxtB4uvHYUCbqlfLNaMthxxbwMmJlwzZ3vh6tQr0nosQIDAQABAoIBAASgNg4Yx3HSnKmmrR8pxnrc5THBTg5Mq+rG3ghFu7Xw0+k5Sn4H7aD7Rsb97TNM8f00dshzXQP5orjeUZDP03ycUVRhpZcJGnQZS3yZT+b0os3ND/ZcwUsaFby5qcfB9MAYtOQ2nTEiMl3LNHQ2Si2/QMvQuttMrm4R2qC/S8lnjzhcyAxnYJ02PSW2wI7i/lio/Vzj9pI1vOEPKlpHgV1zVNdaduhNmkgdKaJ/fCQfmIBtGt6SC++QyomT4oByw2Wxqx5E0TcZ5/hZ/3zaPW0oYHNoUc9YKBVtaFBw78BwwJJhTEYbWCaIQS0YW5Jozd2yw7CyA7CcIZTPx1jZ0k8CgYEAzLmFd8AjUB2R3FWH+7s/LYNgy6ermIF17Raq7jaGdlC/oQ2RslExEcPv6jHeqEos8SCLWgj7sGn1DGMhZ/SSeoJ6xMk9qdivkON01DkqiILrWwlzM2XQzntGuTX1nQee3esTV5B022gZTSoRD1vf8qLJmLPNumu2u8nD4FPUmCMCgYEAy+l3A8nx+MkZ6JLC1OaT86Shr9A7Fywi0oKJVGlGpff6yc/TFRuRckRi60ATLd4FlXaL+DsoEcc3WErNy1oZSbRliLDxlzuebSykzCtz0sse8S+pNCRs49y6yAwIQZGPj78JICcdJyH+lMtTAjT7hALDHNg8nZRB67fg1b4R/xsCgYEAgcTfa2bpe3Ei8i1tQw4QIAN1KeKgjM0TOTPzKYh6dyj8L1RwlD2PAxnWS/dMkhRipH3ilzG2iL7BTBbSKBkJeIqY04BUjAMEVq03cwbBhUKneU9mLKBPWXMfA2vGwsD/3N+TpR+2UxWLZDRUGA4+yIiTjS38LDz22dYtSVcaHU0CgYB31FX1awqAiiVokD5ggLP3XQsLV5IyFuTL0pxDd65lwCmnyTKhV9cMUHXVC415ydx8LfMpSBJPCERU5Xi0hNkRgCqevmTq28VJIRAjT3G8MVOYpsqHctRuv3sgLjn31kOIVNpXA8VVBtwlsqqwRFR+CmWAoO5WKBbpH+DHmu/WewKBgFs6Ld0KwUfwc4rYTxxLkjDoawUz+VuBmbxSUbD5+cdw9KFABv2jP+T7pfiNtJo0ToVlycQ9E0FDjBVzFdV7LUvd6jBbTJYCIIhz7awqUgWc2UkVZCDBiCo+xXL0bTFqGaPTkKqCWNK43IDKmaacIK255bwrcWRroshgR58xkFsW'),('703f979c-0bad-4b1e-882d-fdfac376f4c6','89998d0a-2d7f-4dd1-a97f-44603e805091','client-uris-must-match','true'),('7c4c25b1-ad38-49b7-9c18-2f6a320e7d26','21682e8c-aa3a-4aea-b022-5b5f919e30b7','certificate','MIICmzCCAYMCBgGbKPqpPTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUxMjE2MjEwMjU0WhcNMzUxMjE2MjEwNDM0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDyN5a67bjSstR/Dk8aTv9JRy+W7/KFdn7/YKC/ca8uEPgzAfQCIXUPDR4KeghAYzjPhHOSCJ51Dk2TT2NJ0ytyb2Uv8vjUEIuefG4qAppLyeHyOZ7pEUCEr5EQXC/RzS8RLgeT1rzDeztXlp8RUxq6NSFSmS5gTBBXo7OrFR96sElS7CbefFSqpg0Yu7VakycBPkTNZQYWXiYJItuUE84qn12nzVwrIFsfjzBQajqgFLurDuHRIQTvYUrcny/bxD8Quregdo5lJuTb5sy4NJpBllmEhIc7ArNaeXeEj/P4e33fCp6/4rZASvGwKfV2c0w6QJhfOWK1J/kXgQ4d6PgnAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAGF0cWg9vci6HgmqySXgxIizU5mBMsvmThioRrZ7sf+MWUpTsQ4nwD4lcPZTabe8Bu7XJMppQbo0h/Co/+RzK4H7ZsVEQyBP4hH286cB1CNKQ/hhr2FiG7D4asLqw8tqkcrU43JtQ/Ss/hpGIU5384sesoRvYdS4yJZkiEuZIlTn5oR8KAmsxQJyiqyGKHfrPfiGIcDmNRNIsCfgz+D4EHnm6MeZE+CzIf51oSBW6S/0y/d/MeJGnp88vm9686JSekSYdIuimAUwJUsynY38DjthEZrVfj8yoMOIxERT59gvnvZ6SGuPaxb/p3V0jpbAdSyLoMfbGd96by5W1K010K0='),('7fda2a20-180a-4306-a48d-681e0f6d8f7a','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('839f45a1-5789-48b9-9794-04a61b13579e','eefe6a53-a342-4790-a16b-4e511f784780','allow-default-scopes','true'),('85add96a-e75a-43f6-86b7-2bd268f55f9e','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','saml-role-list-mapper'),('89426c7b-cc6b-4256-a866-ae122d76a7b8','2e375d98-c3de-4e92-9b6c-4937cdf1f103','kid','41f8346a-2768-42c9-a86c-73bd3c15441d'),('8f9c4142-0823-424a-9a98-b74c547f7a36','da554b40-b8de-442c-a89e-4cedf18faea3','priority','100'),('90f29c08-b729-4c09-a4de-4667044a0174','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','oidc-full-name-mapper'),('9278cc20-ce84-40c6-82f9-41b29cb98176','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','oidc-address-mapper'),('93c4cf59-f29b-4485-bdab-475cea6c4cfc','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','oidc-address-mapper'),('93ed44cf-5c14-46a4-97f4-185b7dd3d2d4','21c668c0-041f-44fd-852d-82974d700db6','priority','100'),('9947a5aa-99e1-4e2e-890f-152c70e603c5','0d7190e4-d287-4c96-8ffe-1a4186577c31','secret','V-0y0OuhFgLbxwcCOOWYLg'),('99beebd0-fad0-41a0-b33c-06d7ff8aba94','55f6a270-95cc-4c14-89de-bb3760e82aaa','allow-default-scopes','true'),('9af61b9e-9cca-4f2b-a327-0706e8b8b7b1','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('9bc50c51-4ef2-47b5-ad23-c121f2bbc737','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','oidc-address-mapper'),('a0e70f57-02b3-4ed7-bb5a-67fdf79ad220','d4247186-8801-4626-b620-00d1c03dbb2c','host-sending-registration-request-must-match','true'),('a1f64b8b-4da9-4fe9-a32f-67e590ef12e2','7a6d3342-be01-44c5-884c-4c7af2304ef0','kc.user.profile.config','{\"attributes\":[{\"name\":\"username\",\"displayName\":\"${username}\",\"validations\":{\"length\":{\"min\":3,\"max\":255},\"username-prohibited-characters\":{},\"up-username-not-idn-homograph\":{}},\"permissions\":{\"view\":[\"admin\",\"user\"],\"edit\":[\"admin\",\"user\"]},\"multivalued\":false},{\"name\":\"email\",\"displayName\":\"${email}\",\"validations\":{\"email\":{},\"length\":{\"max\":255}},\"permissions\":{\"view\":[\"admin\",\"user\"],\"edit\":[\"admin\",\"user\"]},\"multivalued\":false},{\"name\":\"firstName\",\"displayName\":\"${firstName}\",\"validations\":{\"length\":{\"max\":255},\"person-name-prohibited-characters\":{}},\"permissions\":{\"view\":[\"admin\",\"user\"],\"edit\":[\"admin\",\"user\"]},\"multivalued\":false},{\"name\":\"lastName\",\"displayName\":\"${lastName}\",\"validations\":{\"length\":{\"max\":255},\"person-name-prohibited-characters\":{}},\"permissions\":{\"view\":[\"admin\",\"user\"],\"edit\":[\"admin\",\"user\"]},\"multivalued\":false}],\"groups\":[{\"name\":\"user-metadata\",\"displayHeader\":\"User metadata\",\"displayDescription\":\"Attributes, which refer to user metadata\"}]}'),('a20e4d79-59ac-482d-88c2-055b457cc120','39c1f564-bc07-4d04-b409-0b676ea29509','keyUse','ENC'),('a21f8925-f4cc-4dc0-b871-09f7c23ca9a4','39c1f564-bc07-4d04-b409-0b676ea29509','priority','100'),('a23328e0-b3a1-4c26-b504-06c46650fab1','21682e8c-aa3a-4aea-b022-5b5f919e30b7','privateKey','MIIEogIBAAKCAQEA8jeWuu240rLUfw5PGk7/SUcvlu/yhXZ+/2Cgv3GvLhD4MwH0AiF1Dw0eCnoIQGM4z4RzkgiedQ5Nk09jSdMrcm9lL/L41BCLnnxuKgKaS8nh8jme6RFAhK+REFwv0c0vES4Hk9a8w3s7V5afEVMaujUhUpkuYEwQV6OzqxUferBJUuwm3nxUqqYNGLu1WpMnAT5EzWUGFl4mCSLblBPOKp9dp81cKyBbH48wUGo6oBS7qw7h0SEE72FK3J8v28Q/ELq3oHaOZSbk2+bMuDSaQZZZhISHOwKzWnl3hI/z+Ht93wqev+K2QErxsCn1dnNMOkCYXzlitSf5F4EOHej4JwIDAQABAoH/K4XRj8UncLSxeiMYE6IePQyNgJGdAl5Ic5rpR30l/SEPeBrhvYBFiG7S9w72bJtnmeIy4gqqbl4jklSxgpJvPCDIDdWa4IAYlmHFaccN8pBUCTJRW4++CBmD92yZKxmzW2Lp+aacRIPgJdzquDI2mz7wvebIboU8aoL/xb4F6gVppGWkAiE4ENe+tC5LeuqizUPCtpBe0soaFcjq4aE54rSBPT/am6cdgYeR3MXPLCCm11yg3n/9H+kWWo++fcPl5KVfRe2990xgkzZH65nLuXK6bt7qQ3ASjicRP/pLxxhiFVw77YS3eiPU3eVSkqOYHWpWxiHjHhspCo1GMDTBAoGBAP63Tk/t1DTYLEj3JemrcExuf4d2D08XxVhgUHdzGArTUFrdvZ4+UZl0pvWT2i0wwqH4tGeM7yLWZTeGFQ3pjJXF5P+KPEMKct48Xv7BtmGqh/pvTVJX/k86HV5d7IOCkjA30IQjOV3roN7N57GBtsAjVy+gxOYLkEXNGHfGV2aXAoGBAPNwJ2VhPR673v5OhRt732zWFKc0Iym1XABxzM+5w4NBbjrATHDOKVcLfhGZQ/d6zYOcBGK4WaFndVSmaDJZHzvjoifXVgkoZDPZd+kNaYpCOF++Z1sYtJvRMa0r8+EgQXOdhj/3FRAB+9Wg/m3esHzDYVFt6z4Nzc5MAqh72jzxAoGAXM3gxJJ8jLxudi9GKvsBsXdZE7vaHBEnH+oHp13R1q/jSRgdbDh8dpLf+f3isjBf2a/J2yioQGMpAa/in+0GAdPWeZyeFDcMXxhT7DIcBz2gyYgf/e59g9RCuw0xjUDXjqXnXR2QWz3soQEYd74xHZRCweGrm71+1U/CqHEliwUCgYEA8nrRUwMjfTyHJuoRXcnqR5+KHO4q5D2YsXypFHQlkdUXtf+bZHWF6gUxgtgWQikZEjHSkH6uEL5buYCzowrwuJfKCkNMmHyaKqc/8GyCpsvFGWEv1CZsqBQcljCEkMavSzkp4wb6/OHs9eKR6+B4DR4UDqcdPcdEK2u87hPH0xECgYEA9ToLFWR66IE9qWyd3vbifPj9rAkSey4OMUeIYSrC9CK2v3kIz6o/cxOYcVEydW8ydZZd+a4d4C4s0eQdk2E+KJxHZQuk7YMLC73PydKKXqTSvTMLjauHpAssKKpP23u1l5llU+uLJ/KgVd7rgUFjGuROBdqxmHXSnb16V6LfqMA='),('a384e5e1-076c-4152-adb2-3ef5fe5e6f2f','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','oidc-address-mapper'),('a5dc6a59-8aec-4cf2-92c2-e4f7625ace67','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','saml-user-property-mapper'),('abf94cef-7366-47a8-9abb-d4286cdb4bf1','39c1f564-bc07-4d04-b409-0b676ea29509','privateKey','MIIEpAIBAAKCAQEAsl78PwvwCFfj7KDs9Hw++D93qT1VfRPxK+/GHQaKlR5QB4U+FpeSdUoG1y1RY4L4T+G7C+sDcMU75I1b5X9kQnadu7OofurCUlKn2s+c4NLn03/5DL91C3E9f8R78AhcahWFsmD+SK4U+h0ukndT8f9CRcTFCH0y22v0EUFm4ljMsmGXrlJHYjHfzDwb0docAwEo7RYM6N0jy/++utVFLEL/7VKB8nQyBM7Mg3J8rtqWEnUXtoXIlHsRCds8sjrUYd0vm7DLnkZaMwXMuerJKonvYF8YQj+uENdAw1qezMavFoIOmds2YUXggmZabKteQppjIh/AaSE9zamHniYcDQIDAQABAoIBACcDDtUEOaK9hFh+Bu1fGk+l4/hUNZUmbi5Pois5gchlCZhnfEGpM4trHi1kWEN1QvWHt6b+5vD8dmHByBpc/zLpKg0CWYUut8MVGGjLVTK39iPEPtaarlELGqoN8ZR5Y6sBG4182MjRKD3e8Y9vwWCxlU9YnsaBSYUDqq02enfhGiJcGAwnT+TLA71C+UT6B6v9OUPu2Eg2rR+3Fme7tOo6LGsV6IJbyRq8+JwOBm7bbG+4YXW25PFaLIn8OrUXeLPNJLLk+pdxG+0UKbhJo79LCs+z0NsYLbW/+3IzLZnS15HKr54ifPKuMWyshsK3AL6Epz5eTG8nzElLbvOsCvECgYEA2LRKI7ZsA70arJIKBNR+yTMkTw9hZ1SYVkwiGXvVvGPFLXfUWEB+mggBTgEWc8OiQckaUsPpLBdzzBW81TJSpJ5QQioxy03SpJdACPL2gUvyp5fZdnmhQytkXU69sWK0V3/9YTvKxs0sVnCbslDZ7zYurgAEBitpYm3GcPvHUd0CgYEA0rc2/ajfKNuIqeyPI7qqtC35HB+myuWAQcYtN+SRGoamM2p9XvG8hd0b4BGW41bR4R02ZzwgO1f/iJGJN3teCyewg3GixBnS4glFL4gUrrnjVu7el2CcXf5mcOqbYtWjfw002W5eUlRwn1/Tuw7ntdhPy/U2TVqyPtgIDdmJB/ECgYAJtiKwcQdsL3hXjX/ncYJxD9qrtFvAHrlo/KZ2j+cnNy1p+TnJ7rH9wygTz9aqv3SxEAse9GqpsC9fUQYSY9vyRqoAHRX4L3emKqUTAZhsePPZ8OMs/QxuDy7DQ7kajvrYBQNc7SoMOLuo8Aj6N8dcgggbgiKsCBwD7jl7bL0k/QKBgQDL8CEb7gZWH+usMlTzSqYOjvQr4QJoGyk//5MiJmi92JYg6y795k8E7FQfUEbOLuggzUorLkkvxmJ+BgVdGlyRxU8UWLYkv62XsUsxzq3d0fGS4Mu0jP+qBR+Wp6nORWDhBaIh0q0dV7ZMuc1NnQZrvDi2+NQel+ot4p4g8WqrsQKBgQDYon5TLsopK1QFqsLAx2ofcTNRKQRXjau5XpF9DGkwSnxiwgkgmw7FDNwp3sQcryKjsSedmrjZGX+NJedZVoB/z3pa5UnhI0omLmTbW7hZvpMqpcxF5wlK4ga2qUln5Qjg+tz53bWvcjrVSoblkoAGPYKKBxlKHieygO6Qr9gbzQ=='),('ac166775-d0b9-496a-9332-6370e76a84e7','5b1bcdfa-0fd8-4576-8af9-d0b709497e2c','priority','100'),('ac8b23d9-3a27-4a98-9c02-19fc1cad38dc','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','saml-user-property-mapper'),('b03a011d-5d7c-4c4b-a7cd-053bac61a22f','da554b40-b8de-442c-a89e-4cedf18faea3','privateKey','MIIEowIBAAKCAQEAv/ECpvQDbVf3qhYqtAuQ7Q6wq04RrNGWsKNNSW0s9HYOilYEl1AL5ThaKBzlc1kpJTUjcvzVPCXK0FJrVbhZ+9yrSODymbpvosQPEaLTevQTZIsSmNBHO2bVWM4xQ35kqzPi8M4AW1Ym0RqrncwmB1JcSBH8yG4N0Mz16mT9WOySUqe0TP4LXkPVyH4UZNqE6hFvlMGpjz9lRkM65PmgkclNmEOEIVCOxFe9k9TV9OR5a3nfTWpPcrrq1+2C5puahDNVKMD5mCAnjDvv6YcENBLnvztS8+5pOWjF4GFTjoeGPnrIONUHtF9EI4YyJVF+HXEpBvZRUwj3yow2uGvF6QIDAQABAoIBAAhnn4/begXw9uuX/mU1Z3J19Pb/W2dHozNXZ0Q6l2AaBk947kkI7IhsRAhjIYoAQry6G7QGjbjNR9kA7unJQYl1k3uEvCLOpuJH9wf06xFEfE/oBheycRgRC/EQUFhuAa78fejBAIN/XYJFCnRFsvmZmehe/0Rwi0LUIsWRiAV7fQ6mW5oqzzonoef+URG4OjFAPNv2inxEvYpVbDUllm/p5EgfYX2RmpafpGxxf3g/0ORZOIj7S0jHYKTqDW8i3dhJSIVoDrp1ZJADUGdGdugdeMd9VWQbByIuyl/h00yLxxvgJoeuCuulOSGJe/UXqqZPvRs9pB68Bu06IMQjO6ECgYEA4uCcKkwB4JJXdwzoN2+s7htlfcoPBdrQ47ivT6jeVPbZDDPJkhMHJmMWs/Nwv0fxJGXXdgs1McrZhdH+GcNeAC+NomRbEdyd1EU4tlqXyO2BM1fXScClZ4zsnI9mDNvC0d6vNQvwC9e/8o28MFV8LDiZW0KtI4bWiZhycdUtdhECgYEA2JRf809LNqRUBbz4c++wD68Tl6zparJWZI3qZpnbxdzJvtZx/v7HWmYYYKl5hzWtq/Be9Y/r5fZSsY77tl+g+v6S8ANCXeKGrBc7NZSnzjxuyjIrSf3suTgqqo+b4EdP/Iz/7NfI/IOalqFDnkAtepLwbpuQOM2tlnjWIQOgGlkCgYBtXMYKYX8aKJC+01rwtgVO9afTnd3l/Zdp3fGr3YPmwuLXTfNhVYjByUv9TGDR47Tqzaixvy9SJCz8o7/v3UvnnQSR/fwkPQtbck6nID5AXbRE8pfVdmaE5tp7kWgo1Joxnj0ovetlWgetvQK07dAgZNwPsLFTCcFKrFCmbJMwcQKBgQCiAYMwnqzVZ+DOFggHuVCKuty+BYLo5BQJzbp8GzUxcbGbxg+pve1jaqFrlPoqMPYDep+dspW0BCjhVuJlDm19svY5AUcgsXUpv4rzzoojlEMPjq2hAIeWGTSZNylTgCSN9u7tvJBEizEU4faRptIeMVIWetlMFFZ4C1Wphmu5qQKBgDmgL1GBLo+Vuj4HUHWfmk/awVea/AaS2DVOTxndz/B34oVs6GrHLvKbkcgMQu1o+ZGqAprGAbiFgzB4+YTj0LFTPx+AWK6onjmN/eO3NIlTFOl9R5hmHx3kOXR/FjTs52YkXEcq0oPG/WC6PT8E1bgPXLEN0IFEmpGdrhU5G2+U'),('b5c25fc7-4e16-46e3-8d89-d2fb240c3dfd','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','saml-role-list-mapper'),('b5edd103-800a-4f15-b1a7-892b241974a1','5b1bcdfa-0fd8-4576-8af9-d0b709497e2c','certificate','MIICpTCCAY0CBgGbKPw2rDANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtmbGlnaHRob3VyczAeFw0yNTEyMTYyMTA0MzZaFw0zNTEyMTYyMTA2MTZaMBYxFDASBgNVBAMMC2ZsaWdodGhvdXJzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoxHQ3bQQRsk/gKxXxqy16IhG3i42xzA2H4gJPsXt3Hb0CncuthI2Whk4nkmyUBRWRtAsvbeUD7uFWamqiHz2p7hxOz/gJbckEG80ksoFdlh0HVbl6LeXN6RaALdSeNZxY+jyewJT73Jf3bxsQ0zuqyOkmn2JxiEmEU6LWocogwHxosepde1hqIGZeFBOLfTX4RIyeGaCQrbgO7KPsBlnKOs0Kvmn7ZurDyxk86JcY57UwJhYvBfgNmxst4V8CCK7j5QWORWcscFFlDhIwNc88QKE0OiTgMM3J3qT0BQe+/RxtB4uvHYUCbqlfLNaMthxxbwMmJlwzZ3vh6tQr0nosQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQB794ziM88K0ZrkKL3cpqlHDZmobb4Dji1CK3owhbgCYxO0gF/yB+LtjjIPUt2PpOiLqSwviht1AOyMk4CIPvtApjuhDez9HtT967lfNYi5/Fhp0qQcnuIzA5SAJkfo4rfe8NG5eWI1bNX5ikbU9geZjEtaxTgcX6UEes8xp04WcYEvXvKFYpJqOg993fh4OFsVJcOp33hc0phuESrbGOCR7LGuYdnVlXvnRbhpc0ephEqdytRFxLffHFRJ5/HpFVDZ8CrevFHPzuNoGFw6p0VaVDEAIzycFl1FaGKREaJFENpgJvRHQbIqTYoiC9W5dgfHplaKVZrvr0RasfCJcuoi'),('c341d513-7035-4196-b155-55c9562d7f22','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('c65142ea-26a9-4b6c-8b05-0a8402622670','9b769ff5-f71a-4ce0-8c55-3801d221d238','algorithm','HS512'),('cec42df9-74ba-4e21-84b7-6b4c99ef1a07','a5d2e1be-d39e-4d34-a35b-cb7705606521','allowed-protocol-mapper-types','saml-role-list-mapper'),('d472d66d-0157-41c6-910b-c9df8d7fc2c9','21c668c0-041f-44fd-852d-82974d700db6','kid','d37fb9ee-7dea-498a-bc4c-1c7903d34fb6'),('d78597e3-a8d9-4aa0-b323-e1c62195a162','fe3ef56c-150c-43c0-ae2c-d4408b4199c8','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('da9ea3d0-5926-4541-9ba0-a4a4fb5351a1','63244a9c-7340-4d3d-b4e4-587479b806bf','allow-default-scopes','true'),('e5035e8c-4290-494a-950f-57e131138452','5b1bcdfa-0fd8-4576-8af9-d0b709497e2c','keyUse','SIG'),('e69383f2-bd5b-4192-9083-9ec89069eb47','21682e8c-aa3a-4aea-b022-5b5f919e30b7','algorithm','RSA-OAEP'),('e71d9992-7d43-49e7-a3f2-8480b67028a5','89998d0a-2d7f-4dd1-a97f-44603e805091','host-sending-registration-request-must-match','true'),('e940e144-37fd-4395-bdba-217dfbe6cc6f','2e375d98-c3de-4e92-9b6c-4937cdf1f103','secret','ijRw2wR-Ud7oF1WHObvmKQ'),('f0e89a3c-a27d-4a04-a5b6-0fa2bb926213','39c1f564-bc07-4d04-b409-0b676ea29509','certificate','MIICpTCCAY0CBgGbKPw3NTANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtmbGlnaHRob3VyczAeFw0yNTEyMTYyMTA0MzZaFw0zNTEyMTYyMTA2MTZaMBYxFDASBgNVBAMMC2ZsaWdodGhvdXJzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsl78PwvwCFfj7KDs9Hw++D93qT1VfRPxK+/GHQaKlR5QB4U+FpeSdUoG1y1RY4L4T+G7C+sDcMU75I1b5X9kQnadu7OofurCUlKn2s+c4NLn03/5DL91C3E9f8R78AhcahWFsmD+SK4U+h0ukndT8f9CRcTFCH0y22v0EUFm4ljMsmGXrlJHYjHfzDwb0docAwEo7RYM6N0jy/++utVFLEL/7VKB8nQyBM7Mg3J8rtqWEnUXtoXIlHsRCds8sjrUYd0vm7DLnkZaMwXMuerJKonvYF8YQj+uENdAw1qezMavFoIOmds2YUXggmZabKteQppjIh/AaSE9zamHniYcDQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAhJO7F6wdlDjE/d/XAO3M6v70ifotUZ4UVscuoeGia4mPFFJft18uRECDEw2ar5JlTt6JwVw8ESBNcfzQ1125KAkdMZhvf7bflCmMEiHUd/O88krwrcdy+PcY0mFC8O6yrpuYyUHfye2nVHckUMMrEioLCQjBXpiIcfVOhI0iO0d7G+fcf4gwkZq2V9feeUGAWnJSNldZTwmJO+VrsMjZvmzfXDf1RZRiJg7KweIPKp/0jbK2UKEY1J2ruJcO3p4WOXFEI8RY8ZNjZrZlv4NuoLICE6hEI4/5jS/ZfE1NcVar7RpWW7e155xTmIgWLDXKia8YWDOGmeaSZ9fNz4X8R'),('f94bc96e-d774-4d9f-a370-70e1b39cbbac','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','oidc-full-name-mapper'),('f9a1283d-717b-483c-8958-aeb16ff49315','5f3a13d6-3c42-4bd1-9a27-faf6943a196f','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('f9d7f0bd-c739-4ff9-94ed-f189d430baea','da554b40-b8de-442c-a89e-4cedf18faea3','certificate','MIICmzCCAYMCBgGbKPqoJzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUxMjE2MjEwMjU0WhcNMzUxMjE2MjEwNDM0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/8QKm9ANtV/eqFiq0C5DtDrCrThGs0Zawo01JbSz0dg6KVgSXUAvlOFooHOVzWSklNSNy/NU8JcrQUmtVuFn73KtI4PKZum+ixA8RotN69BNkixKY0Ec7ZtVYzjFDfmSrM+LwzgBbVibRGqudzCYHUlxIEfzIbg3QzPXqZP1Y7JJSp7RM/gteQ9XIfhRk2oTqEW+UwamPP2VGQzrk+aCRyU2YQ4QhUI7EV72T1NX05Hlred9Nak9yuurX7YLmm5qEM1UowPmYICeMO+/phwQ0Eue/O1Lz7mk5aMXgYVOOh4Y+esg41Qe0X0QjhjIlUX4dcSkG9lFTCPfKjDa4a8XpAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJkYdovNcoQ7QcM7iCkrEEgCqZPpFdxEIjPq0zMk8OzeQE2lwjY4C8LjAm+OYsJ3pKDyoUFXuoOj0VlPo1pl3/QPSu7EnZWmetksIUBWQCY/z/XsbTgYSFbiAPf2VXNDrVoFx+do/DDBnahK6pb28WNhbjNeITSTavURZia9ZfnrG6jRKqaSCxxWv3tkxrwurloLF/L0r2KSTrxv7TlIfY7yxvbUL3lDoy/HtESjp1HVxq6t1xBxs5JMTF/9PGCFolwH6mrnseVFnEN2qdCB9nfLEE0LV/GBnNkmkLftGMSWdfspooqiisCmTrlY+SBBy/qT8nw/fKKaHZO+6lfxrbQ='),('fa4c291a-fb84-47d6-9781-92de174aa2af','2e375d98-c3de-4e92-9b6c-4937cdf1f103','priority','100'),('fdaf9234-07c3-437a-93bc-faafcdf55488','1afa532a-20cc-4a30-bc89-5a5c0ac43ccc','max-clients','200'),('feb20bc5-984f-4122-96ce-ef88de009f9c','dfe3d4da-b5aa-4011-a6b5-b4d5202b8088','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper');
/*!40000 ALTER TABLE `COMPONENT_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMPOSITE_ROLE`
--

DROP TABLE IF EXISTS `COMPOSITE_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMPOSITE_ROLE` (
  `COMPOSITE` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CHILD_ROLE` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`COMPOSITE`,`CHILD_ROLE`),
  KEY `IDX_COMPOSITE` (`COMPOSITE`),
  KEY `IDX_COMPOSITE_CHILD` (`CHILD_ROLE`),
  CONSTRAINT `FK_A63WVEKFTU8JO1PNJ81E7MCE2` FOREIGN KEY (`COMPOSITE`) REFERENCES `KEYCLOAK_ROLE` (`ID`),
  CONSTRAINT `FK_GR7THLLB9LU8Q4VQA4524JJY8` FOREIGN KEY (`CHILD_ROLE`) REFERENCES `KEYCLOAK_ROLE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPOSITE_ROLE`
--

LOCK TABLES `COMPOSITE_ROLE` WRITE;
/*!40000 ALTER TABLE `COMPOSITE_ROLE` DISABLE KEYS */;
INSERT INTO `COMPOSITE_ROLE` (`COMPOSITE`, `CHILD_ROLE`) VALUES ('09db3cfc-a054-4e96-82b4-265054497be8','4af7faba-58c9-427c-9197-e548ef944941'),('09db3cfc-a054-4e96-82b4-265054497be8','deb4ef45-876d-4ab5-bcd0-febe09244597'),('0be0f161-0bfa-4df1-b7b0-c83a1c88ec75','5b2ad3b7-b067-4fbf-9b43-5fd86d3896ab'),('0f682252-2190-4bdf-a65e-1c9cc5d1a130','67edcbdd-c6c9-441e-a27f-ea6c7aedffcc'),('0f682252-2190-4bdf-a65e-1c9cc5d1a130','7d02219a-ef97-4500-9c3e-ee6de52bf465'),('0f682252-2190-4bdf-a65e-1c9cc5d1a130','ba12455a-29fc-4a9f-88c3-f4df58d641bb'),('0f682252-2190-4bdf-a65e-1c9cc5d1a130','e7c320d9-b58f-49d2-9ae9-58fdded3abaa'),('14ee911d-3e03-4aab-8caa-a313db1795f3','27a8d6a5-4cfb-4793-ad02-fb0277599d6b'),('14ee911d-3e03-4aab-8caa-a313db1795f3','89102a66-0a55-4ee7-9558-8e6edcd130af'),('23239c07-76bf-4e99-bd63-28350366b303','026c9e72-b023-465c-bf75-bdc8516b26c6'),('23239c07-76bf-4e99-bd63-28350366b303','10fc5f89-ed70-4bd5-834c-6fe55da79eb9'),('23239c07-76bf-4e99-bd63-28350366b303','35cedb35-3ef6-4343-a0fd-61766d82ef4a'),('23239c07-76bf-4e99-bd63-28350366b303','3d726bac-5a8f-46bd-9629-7e5c8d180138'),('23239c07-76bf-4e99-bd63-28350366b303','54a22128-248a-4632-bdfb-3462a684a4f3'),('23239c07-76bf-4e99-bd63-28350366b303','585558bf-1a85-4955-9343-172c7b92ad8f'),('23239c07-76bf-4e99-bd63-28350366b303','5dcce07d-25b0-4a2c-b5a6-e8fa23fc5e66'),('23239c07-76bf-4e99-bd63-28350366b303','7d6f7d58-447b-4807-bf0d-e52855574c88'),('23239c07-76bf-4e99-bd63-28350366b303','80add76c-f7f2-4bad-ab92-eae1fd77853c'),('23239c07-76bf-4e99-bd63-28350366b303','8a33dbd8-cc74-4b3c-aadc-c841b23883e7'),('23239c07-76bf-4e99-bd63-28350366b303','a934b7f0-714e-4c21-bcf2-c603daa4313c'),('23239c07-76bf-4e99-bd63-28350366b303','a94d1665-92ef-4f2b-9b64-37a83fea21e2'),('23239c07-76bf-4e99-bd63-28350366b303','b3c65021-7052-41a1-b994-bd522a35bcea'),('23239c07-76bf-4e99-bd63-28350366b303','b9c9053f-8b22-405f-9f5c-fe26dd836334'),('23239c07-76bf-4e99-bd63-28350366b303','bb400aff-c02a-4b6f-905c-6f0b67c2ca56'),('23239c07-76bf-4e99-bd63-28350366b303','dc18ea96-139f-49b2-8465-4ca3fc89b567'),('23239c07-76bf-4e99-bd63-28350366b303','f5ca9c99-8f3f-41b0-819a-afaaa960b598'),('23239c07-76bf-4e99-bd63-28350366b303','f730dd50-853d-4aaf-b092-119b362f0974'),('4e0868e7-ca25-45be-a018-a8ce2d8aa842','8c7d8cde-93d3-42dd-aed4-8002001e61fe'),('5dcce07d-25b0-4a2c-b5a6-e8fa23fc5e66','80add76c-f7f2-4bad-ab92-eae1fd77853c'),('5dcce07d-25b0-4a2c-b5a6-e8fa23fc5e66','dc18ea96-139f-49b2-8465-4ca3fc89b567'),('75ae6bc7-9d48-4be6-b9b5-7a0b6c7f4a61','88686a44-1f56-45e9-afec-72f8013c91b4'),('a653c42c-b5ea-40fb-8115-54e4eb8861ec','27724851-5224-4b3d-aa0a-c4da122b65b5'),('b3c65021-7052-41a1-b994-bd522a35bcea','3d726bac-5a8f-46bd-9629-7e5c8d180138'),('ba12455a-29fc-4a9f-88c3-f4df58d641bb','65d829ba-a5c6-4c13-84d6-5d2d57a3920a'),('cd2d8d15-d077-4e3c-b873-ab0327bc93d2','8c0e76d1-d061-4871-95e2-52df7f44ee8a'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','0be0f161-0bfa-4df1-b7b0-c83a1c88ec75'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','358e8af2-c185-4c50-99f2-4965f5f9a96b'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','3f98208c-06a0-4d22-a3f2-689d2300e576'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','61d078d4-1e5c-4326-978c-295428d41c62'),('ddacf774-0aef-4361-9e41-4b35ac252eea','09db3cfc-a054-4e96-82b4-265054497be8'),('ddacf774-0aef-4361-9e41-4b35ac252eea','0d08b3cc-c18b-4d64-866b-07eab8f6a7b7'),('ddacf774-0aef-4361-9e41-4b35ac252eea','14ee911d-3e03-4aab-8caa-a313db1795f3'),('ddacf774-0aef-4361-9e41-4b35ac252eea','1cc06174-b1b7-477c-8491-be1481b24dc3'),('ddacf774-0aef-4361-9e41-4b35ac252eea','1d210159-4c61-465c-9708-08bf2f08b44e'),('ddacf774-0aef-4361-9e41-4b35ac252eea','224ea08c-7ece-4c9b-8718-147ed4094b9c'),('ddacf774-0aef-4361-9e41-4b35ac252eea','27724851-5224-4b3d-aa0a-c4da122b65b5'),('ddacf774-0aef-4361-9e41-4b35ac252eea','27a8d6a5-4cfb-4793-ad02-fb0277599d6b'),('ddacf774-0aef-4361-9e41-4b35ac252eea','31aa74c8-be92-4599-a411-c2e4d0e701ab'),('ddacf774-0aef-4361-9e41-4b35ac252eea','393a73d2-0ba7-42df-b646-12c1f5585de5'),('ddacf774-0aef-4361-9e41-4b35ac252eea','45f418d3-8867-4f2e-a265-e62497a53c12'),('ddacf774-0aef-4361-9e41-4b35ac252eea','48577b46-6b30-4169-ac2c-85edd8cfc11c'),('ddacf774-0aef-4361-9e41-4b35ac252eea','4af7faba-58c9-427c-9197-e548ef944941'),('ddacf774-0aef-4361-9e41-4b35ac252eea','517d4f3b-2c0a-4859-858e-e8210273d456'),('ddacf774-0aef-4361-9e41-4b35ac252eea','552eae8b-b7ec-4117-9c6c-57c20b4f54f6'),('ddacf774-0aef-4361-9e41-4b35ac252eea','731a8627-3f6c-4a47-847a-18ab45194f00'),('ddacf774-0aef-4361-9e41-4b35ac252eea','7ca1f358-ef99-4274-a4ff-d33fc146a115'),('ddacf774-0aef-4361-9e41-4b35ac252eea','8572e882-5644-4acc-954d-dbdb7f9a378a'),('ddacf774-0aef-4361-9e41-4b35ac252eea','87052c65-5102-421e-a477-c8ecc3f7c98a'),('ddacf774-0aef-4361-9e41-4b35ac252eea','89102a66-0a55-4ee7-9558-8e6edcd130af'),('ddacf774-0aef-4361-9e41-4b35ac252eea','8c0e76d1-d061-4871-95e2-52df7f44ee8a'),('ddacf774-0aef-4361-9e41-4b35ac252eea','9ebef503-961f-4745-8da6-e9cbdc1caa49'),('ddacf774-0aef-4361-9e41-4b35ac252eea','a653c42c-b5ea-40fb-8115-54e4eb8861ec'),('ddacf774-0aef-4361-9e41-4b35ac252eea','a675b148-ea75-435d-82c6-24f12ada704d'),('ddacf774-0aef-4361-9e41-4b35ac252eea','a68d0c5c-00a2-4dbf-8c96-a54d1d6d51af'),('ddacf774-0aef-4361-9e41-4b35ac252eea','c462468d-0b4a-4c8c-8645-429c52eca1ee'),('ddacf774-0aef-4361-9e41-4b35ac252eea','cd2d8d15-d077-4e3c-b873-ab0327bc93d2'),('ddacf774-0aef-4361-9e41-4b35ac252eea','d7fa4be3-60f4-47e1-ad80-4f37fc4d8053'),('ddacf774-0aef-4361-9e41-4b35ac252eea','deb4ef45-876d-4ab5-bcd0-febe09244597'),('ddacf774-0aef-4361-9e41-4b35ac252eea','e274a4fc-0b4b-4221-9c90-b7f77c424fcf'),('ddacf774-0aef-4361-9e41-4b35ac252eea','e51d0bd7-6abe-4fa6-8c9c-cca14c34275a'),('ddacf774-0aef-4361-9e41-4b35ac252eea','ea78137d-26f7-44ac-ac2f-ed65d836f08a'),('ddacf774-0aef-4361-9e41-4b35ac252eea','ef363ce7-69c3-43aa-af66-13fa3fbe3358'),('ddacf774-0aef-4361-9e41-4b35ac252eea','f22df1db-e246-4c6f-983a-2e0bac7f2db6'),('ddacf774-0aef-4361-9e41-4b35ac252eea','f3aa9cac-9cca-436c-9d06-07ebaa0f77a1'),('ddacf774-0aef-4361-9e41-4b35ac252eea','f518b8af-9523-4c26-a507-f69594b78d27'),('ddacf774-0aef-4361-9e41-4b35ac252eea','ff167167-8fb5-4e88-8e52-4a4c03df9cf6');
/*!40000 ALTER TABLE `COMPOSITE_ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CREDENTIAL`
--

DROP TABLE IF EXISTS `CREDENTIAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CREDENTIAL` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SALT` tinyblob,
  `TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `USER_LABEL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SECRET_DATA` longtext COLLATE utf8mb4_unicode_ci,
  `CREDENTIAL_DATA` longtext COLLATE utf8mb4_unicode_ci,
  `PRIORITY` int DEFAULT NULL,
  `VERSION` int DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IDX_USER_CREDENTIAL` (`USER_ID`),
  CONSTRAINT `FK_PFYR0GLASQYL0DEI3KL69R6V0` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CREDENTIAL`
--

LOCK TABLES `CREDENTIAL` WRITE;
/*!40000 ALTER TABLE `CREDENTIAL` DISABLE KEYS */;
INSERT INTO `CREDENTIAL` (`ID`, `SALT`, `TYPE`, `USER_ID`, `CREATED_DATE`, `USER_LABEL`, `SECRET_DATA`, `CREDENTIAL_DATA`, `PRIORITY`, `VERSION`) VALUES ('25398c03-3b4c-4a4b-886b-64d8dd979b41',NULL,'password','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee',1765919333583,NULL,'{\"value\":\"B/ME5rAAsAuzaBhZ0ch0oBeccrKPODqOmeDfrdOktNk=\",\"salt\":\"tcvWAeDwLc+PVbI4CtX8VA==\",\"additionalParameters\":{}}','{\"hashIterations\":5,\"algorithm\":\"argon2\",\"additionalParameters\":{\"hashLength\":[\"32\"],\"memory\":[\"7168\"],\"type\":[\"id\"],\"version\":[\"1.3\"],\"parallelism\":[\"1\"]}}',10,1),('827d2807-b9a7-426b-92ee-48e7f3c7c803',NULL,'password','616357a0-a6e4-4514-94c7-f734eda2a685',1770073442508,NULL,'{\"value\":\"IJkq3GbA/y3KRN+hdixguFwDKY8F3vnJdIl6LHu2/x8=\",\"salt\":\"QV01gV9cIroE/fHNX4HhkA==\",\"additionalParameters\":{}}','{\"hashIterations\":5,\"algorithm\":\"argon2\",\"additionalParameters\":{\"hashLength\":[\"32\"],\"memory\":[\"7168\"],\"type\":[\"id\"],\"version\":[\"1.3\"],\"parallelism\":[\"1\"]}}',10,1),('b33f1d26-cfcc-4157-adc3-60c73d612e88',NULL,'password','1586d5b4-8691-4e6c-9a70-48f06fb8fb06',1770070853803,NULL,'{\"value\":\"AdF0rVjNFgIsTwX7H5gmYimKmfoghisqm18A2vM0uLA=\",\"salt\":\"SEtA+IHTQS0rRiFnBPjU4A==\",\"additionalParameters\":{}}','{\"hashIterations\":5,\"algorithm\":\"argon2\",\"additionalParameters\":{\"hashLength\":[\"32\"],\"memory\":[\"7168\"],\"type\":[\"id\"],\"version\":[\"1.3\"],\"parallelism\":[\"1\"]}}',10,0),('be69d71f-61ab-4164-b50a-f10334b26f28',NULL,'password','fb2b2b63-df46-4b1a-8244-ffa990c06ccc',1770072489416,'My password','{\"value\":\"xaeS2AMWTPRkcaU0Su30BiM+L3JEstI40ZeTa/RFM5g=\",\"salt\":\"XRoFSaOtATodXMR7cNNCcA==\",\"additionalParameters\":{}}','{\"hashIterations\":5,\"algorithm\":\"argon2\",\"additionalParameters\":{\"hashLength\":[\"32\"],\"memory\":[\"7168\"],\"type\":[\"id\"],\"version\":[\"1.3\"],\"parallelism\":[\"1\"]}}',10,9),('de693fa9-56c6-47c5-a62b-aa4507a28d66',NULL,'password','66faf137-c364-4fa3-b82a-1585327fb009',1769959914486,NULL,'{\"value\":\"e6EpAgW79hWEeQ3C5vsZgmRueU0lmsEV++IurbtmQxM=\",\"salt\":\"CnrHJdfUqRHYx2O7CnIVOw==\",\"additionalParameters\":{}}','{\"hashIterations\":5,\"algorithm\":\"argon2\",\"additionalParameters\":{\"hashLength\":[\"32\"],\"memory\":[\"7168\"],\"type\":[\"id\"],\"version\":[\"1.3\"],\"parallelism\":[\"1\"]}}',10,0);
/*!40000 ALTER TABLE `CREDENTIAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATABASECHANGELOG`
--

DROP TABLE IF EXISTS `DATABASECHANGELOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `AUTHOR` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FILENAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MD5SUM` varchar(35) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMENTS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TAG` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LIQUIBASE` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CONTEXTS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LABELS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`,`AUTHOR`,`FILENAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASECHANGELOG`
--

LOCK TABLES `DATABASECHANGELOG` WRITE;
/*!40000 ALTER TABLE `DATABASECHANGELOG` DISABLE KEYS */;
INSERT INTO `DATABASECHANGELOG` (`ID`, `AUTHOR`, `FILENAME`, `DATEEXECUTED`, `ORDEREXECUTED`, `EXECTYPE`, `MD5SUM`, `DESCRIPTION`, `COMMENTS`, `TAG`, `LIQUIBASE`, `CONTEXTS`, `LABELS`, `DEPLOYMENT_ID`) VALUES ('1.0.0.Final-KEYCLOAK-5461','sthorger@redhat.com','META-INF/db2-jpa-changelog-1.0.0.Final.xml','2025-12-16 21:04:16',2,'MARK_RAN','9:828775b1596a07d1200ba1d49e5e3941','createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.0.0.Final-KEYCLOAK-5461','sthorger@redhat.com','META-INF/jpa-changelog-1.0.0.Final.xml','2025-12-16 21:04:16',1,'EXECUTED','9:6f1016664e21e16d26517a4418f5e3df','createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.1.0.Beta1','sthorger@redhat.com','META-INF/jpa-changelog-1.1.0.Beta1.xml','2025-12-16 21:04:17',3,'EXECUTED','9:5f090e44a7d595883c1fb61f4b41fd38','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.1.0.Final','sthorger@redhat.com','META-INF/jpa-changelog-1.1.0.Final.xml','2025-12-16 21:04:17',4,'EXECUTED','9:c07e577387a3d2c04d1adc9aaad8730e','renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.2.0.Beta1','psilva@redhat.com','META-INF/db2-jpa-changelog-1.2.0.Beta1.xml','2025-12-16 21:04:17',6,'MARK_RAN','9:543b5c9989f024fe35c6f6c5a97de88e','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.2.0.Beta1','psilva@redhat.com','META-INF/jpa-changelog-1.2.0.Beta1.xml','2025-12-16 21:04:17',5,'EXECUTED','9:b68ce996c655922dbcd2fe6b6ae72686','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.2.0.Final','keycloak','META-INF/jpa-changelog-1.2.0.Final.xml','2025-12-16 21:04:18',9,'EXECUTED','9:9d05c7be10cdb873f8bcb41bc3a8ab23','update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.2.0.RC1','bburke@redhat.com','META-INF/db2-jpa-changelog-1.2.0.CR1.xml','2025-12-16 21:04:18',8,'MARK_RAN','9:db4a145ba11a6fdaefb397f6dbf829a1','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.2.0.RC1','bburke@redhat.com','META-INF/jpa-changelog-1.2.0.CR1.xml','2025-12-16 21:04:18',7,'EXECUTED','9:765afebbe21cf5bbca048e632df38336','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.3.0','bburke@redhat.com','META-INF/jpa-changelog-1.3.0.xml','2025-12-16 21:04:19',10,'EXECUTED','9:18593702353128d53111f9b1ff0b82b8','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.4.0','bburke@redhat.com','META-INF/db2-jpa-changelog-1.4.0.xml','2025-12-16 21:04:19',12,'MARK_RAN','9:e1ff28bf7568451453f844c5d54bb0b5','delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.4.0','bburke@redhat.com','META-INF/jpa-changelog-1.4.0.xml','2025-12-16 21:04:19',11,'EXECUTED','9:6122efe5f090e41a85c0f1c9e52cbb62','delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.5.0','bburke@redhat.com','META-INF/jpa-changelog-1.5.0.xml','2025-12-16 21:04:19',13,'EXECUTED','9:7af32cd8957fbc069f796b61217483fd','delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.6.1','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2025-12-16 21:04:19',17,'EXECUTED','9:d41d8cd98f00b204e9800998ecf8427e','empty','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.6.1_from15','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2025-12-16 21:04:19',14,'EXECUTED','9:6005e15e84714cd83226bf7879f54190','addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.6.1_from16','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2025-12-16 21:04:19',16,'MARK_RAN','9:f8dadc9284440469dcf71e25ca6ab99b','dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.6.1_from16-pre','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2025-12-16 21:04:19',15,'MARK_RAN','9:bf656f5a2b055d07f314431cae76f06c','delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.7.0','bburke@redhat.com','META-INF/jpa-changelog-1.7.0.xml','2025-12-16 21:04:20',18,'EXECUTED','9:3368ff0be4c2855ee2dd9ca813b38d8e','createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.8.0','mposolda@redhat.com','META-INF/db2-jpa-changelog-1.8.0.xml','2025-12-16 21:04:20',21,'MARK_RAN','9:831e82914316dc8a57dc09d755f23c51','addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.8.0','mposolda@redhat.com','META-INF/jpa-changelog-1.8.0.xml','2025-12-16 21:04:20',19,'EXECUTED','9:8ac2fb5dd030b24c0570a763ed75ed20','addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.8.0-2','keycloak','META-INF/db2-jpa-changelog-1.8.0.xml','2025-12-16 21:04:20',22,'MARK_RAN','9:f91ddca9b19743db60e3057679810e6c','dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.8.0-2','keycloak','META-INF/jpa-changelog-1.8.0.xml','2025-12-16 21:04:20',20,'EXECUTED','9:f91ddca9b19743db60e3057679810e6c','dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.9.0','mposolda@redhat.com','META-INF/jpa-changelog-1.9.0.xml','2025-12-16 21:04:20',23,'EXECUTED','9:bc3d0f9e823a69dc21e23e94c7a94bb1','update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.9.1','keycloak','META-INF/db2-jpa-changelog-1.9.1.xml','2025-12-16 21:04:20',25,'MARK_RAN','9:0d6c65c6f58732d81569e77b10ba301d','modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.9.1','keycloak','META-INF/jpa-changelog-1.9.1.xml','2025-12-16 21:04:20',24,'EXECUTED','9:c9999da42f543575ab790e76439a2679','modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('1.9.2','keycloak','META-INF/jpa-changelog-1.9.2.xml','2025-12-16 21:04:20',26,'EXECUTED','9:fc576660fc016ae53d2d4778d84d86d0','createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('12.1.0-add-realm-localization-table','keycloak','META-INF/jpa-changelog-12.0.0.xml','2025-12-16 21:04:27',88,'EXECUTED','9:fffabce2bc01e1a8f5110d5278500065','createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS','',NULL,'4.33.0',NULL,NULL,'5919052302'),('13.0.0-increase-column-size-federated','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',94,'EXECUTED','9:43c0c1055b6761b4b3e89de76d612ccf','modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('13.0.0-KEYCLOAK-16844','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',91,'EXECUTED','9:ad1194d66c937e3ffc82386c050ba089','createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('13.0.0-KEYCLOAK-17992-drop-constraints','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',93,'MARK_RAN','9:544d201116a0fcc5a5da0925fbbc3bde','dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('13.0.0-KEYCLOAK-17992-recreate-constraints','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',95,'MARK_RAN','9:8bd711fd0330f4fe980494ca43ab1139','addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('14.0.0-KEYCLOAK-11019','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',97,'EXECUTED','9:24fb8611e97f29989bea412aa38d12b7','createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('14.0.0-KEYCLOAK-18286','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',98,'MARK_RAN','9:259f89014ce2506ee84740cbf7163aa7','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('14.0.0-KEYCLOAK-18286-revert','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',99,'MARK_RAN','9:04baaf56c116ed19951cbc2cca584022','dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('14.0.0-KEYCLOAK-18286-supported-dbs','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',100,'EXECUTED','9:bd2bd0fc7768cf0845ac96a8786fa735','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('14.0.0-KEYCLOAK-18286-unsupported-dbs','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',101,'MARK_RAN','9:d3d977031d431db16e2c181ce49d73e9','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('15.0.0-KEYCLOAK-18467','keycloak','META-INF/jpa-changelog-15.0.0.xml','2025-12-16 21:04:27',104,'EXECUTED','9:47a760639ac597360a8219f5b768b4de','addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('17.0.0-9562','keycloak','META-INF/jpa-changelog-17.0.0.xml','2025-12-16 21:04:27',105,'EXECUTED','9:a6272f0576727dd8cad2522335f5d99e','createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('18.0.0-10625-IDX_ADMIN_EVENT_TIME','keycloak','META-INF/jpa-changelog-18.0.0.xml','2025-12-16 21:04:27',106,'EXECUTED','9:015479dbd691d9cc8669282f4828c41d','createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('18.0.15-30992-index-consent','keycloak','META-INF/jpa-changelog-18.0.15.xml','2025-12-16 21:04:27',107,'EXECUTED','9:80071ede7a05604b1f4906f3bf3b00f0','createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('19.0.0-10135','keycloak','META-INF/jpa-changelog-19.0.0.xml','2025-12-16 21:04:27',108,'EXECUTED','9:9518e495fdd22f78ad6425cc30630221','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.1.0-KEYCLOAK-5461','bburke@redhat.com','META-INF/jpa-changelog-2.1.0.xml','2025-12-16 21:04:21',29,'EXECUTED','9:bd88e1f833df0420b01e114533aee5e8','createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.2.0','bburke@redhat.com','META-INF/jpa-changelog-2.2.0.xml','2025-12-16 21:04:21',30,'EXECUTED','9:a7022af5267f019d020edfe316ef4371','addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.3.0','bburke@redhat.com','META-INF/jpa-changelog-2.3.0.xml','2025-12-16 21:04:22',31,'EXECUTED','9:fc155c394040654d6a79227e56f5e25a','createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.4.0','bburke@redhat.com','META-INF/jpa-changelog-2.4.0.xml','2025-12-16 21:04:22',32,'EXECUTED','9:eac4ffb2a14795e5dc7b426063e54d88','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.5.0','bburke@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2025-12-16 21:04:22',33,'EXECUTED','9:54937c05672568c4c64fc9524c1e9462','customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.5.0-duplicate-email-support','slawomir@dabek.name','META-INF/jpa-changelog-2.5.0.xml','2025-12-16 21:04:22',36,'EXECUTED','9:61b6d3d7a4c0e0024b0c839da283da0c','addColumn tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.5.0-unicode-oracle','hmlnarik@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2025-12-16 21:04:22',34,'MARK_RAN','9:ace24a0cf8bb3e7af7fa89f8549f04d9','modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.5.0-unicode-other-dbs','hmlnarik@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2025-12-16 21:04:22',35,'EXECUTED','9:33d72168746f81f98ae3a1e8e0ca3554','modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.5.0-unique-group-names','hmlnarik@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2025-12-16 21:04:22',37,'EXECUTED','9:8dcac7bdf7378e7d823cdfddebf72fda','addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP','',NULL,'4.33.0',NULL,NULL,'5919052302'),('2.5.1','bburke@redhat.com','META-INF/jpa-changelog-2.5.1.xml','2025-12-16 21:04:22',38,'EXECUTED','9:a2b870802540cb3faa72098db5388af3','addColumn tableName=FED_USER_CONSENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('20.0.0-12964-supported-dbs','keycloak','META-INF/jpa-changelog-20.0.0.xml','2025-12-16 21:04:27',109,'EXECUTED','9:f2e1331a71e0aa85e5608fe42f7f681c','createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('20.0.0-12964-supported-dbs-edb-migration','keycloak','META-INF/jpa-changelog-20.0.0.xml','2025-12-16 21:04:27',110,'MARK_RAN','9:a6b18a8e38062df5793edbe064f4aecd','dropIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE; createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('20.0.0-12964-unsupported-dbs','keycloak','META-INF/jpa-changelog-20.0.0.xml','2025-12-16 21:04:27',111,'MARK_RAN','9:1a6fcaa85e20bdeae0a9ce49b41946a5','createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('21.0.2-17277','keycloak','META-INF/jpa-changelog-21.0.2.xml','2025-12-16 21:04:27',115,'EXECUTED','9:7ee1f7a3fb8f5588f171fb9a6ab623c0','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('21.1.0-19404','keycloak','META-INF/jpa-changelog-21.1.0.xml','2025-12-16 21:04:27',116,'EXECUTED','9:3d7e830b52f33676b9d64f7f2b2ea634','modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER','',NULL,'4.33.0',NULL,NULL,'5919052302'),('21.1.0-19404-2','keycloak','META-INF/jpa-changelog-21.1.0.xml','2025-12-16 21:04:27',117,'MARK_RAN','9:627d032e3ef2c06c0e1f73d2ae25c26c','addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('22.0.0-17484-updated','keycloak','META-INF/jpa-changelog-22.0.0.xml','2025-12-16 21:04:27',118,'EXECUTED','9:90af0bfd30cafc17b9f4d6eccd92b8b3','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('22.0.5-24031','keycloak','META-INF/jpa-changelog-22.0.0.xml','2025-12-16 21:04:27',119,'MARK_RAN','9:a60d2d7b315ec2d3eba9e2f145f9df28','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('23.0.0-12062','keycloak','META-INF/jpa-changelog-23.0.0.xml','2025-12-16 21:04:27',120,'EXECUTED','9:2168fbe728fec46ae9baf15bf80927b8','addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG','',NULL,'4.33.0',NULL,NULL,'5919052302'),('23.0.0-17258','keycloak','META-INF/jpa-changelog-23.0.0.xml','2025-12-16 21:04:27',121,'EXECUTED','9:36506d679a83bbfda85a27ea1864dca8','addColumn tableName=EVENT_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.0-26618-drop-index-if-present','keycloak','META-INF/jpa-changelog-24.0.0.xml','2025-12-16 21:04:28',124,'MARK_RAN','9:04baaf56c116ed19951cbc2cca584022','dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.0-26618-edb-migration','keycloak','META-INF/jpa-changelog-24.0.0.xml','2025-12-16 21:04:28',126,'MARK_RAN','9:2f684b29d414cd47efe3a3599f390741','dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES; createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.0-26618-reindex','keycloak','META-INF/jpa-changelog-24.0.0.xml','2025-12-16 21:04:28',125,'EXECUTED','9:bd2bd0fc7768cf0845ac96a8786fa735','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.0-9758','keycloak','META-INF/jpa-changelog-24.0.0.xml','2025-12-16 21:04:28',122,'EXECUTED','9:502c557a5189f600f0f445a9b49ebbce','addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.0-9758-2','keycloak','META-INF/jpa-changelog-24.0.0.xml','2025-12-16 21:04:28',123,'EXECUTED','9:bf0fdee10afdf597a987adbf291db7b2','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.2-27228','keycloak','META-INF/jpa-changelog-24.0.2.xml','2025-12-16 21:04:28',127,'EXECUTED','9:eaee11f6b8aa25d2cc6a84fb86fc6238','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.2-27967-drop-index-if-present','keycloak','META-INF/jpa-changelog-24.0.2.xml','2025-12-16 21:04:28',128,'MARK_RAN','9:04baaf56c116ed19951cbc2cca584022','dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('24.0.2-27967-reindex','keycloak','META-INF/jpa-changelog-24.0.2.xml','2025-12-16 21:04:28',129,'MARK_RAN','9:d3d977031d431db16e2c181ce49d73e9','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-2-mysql','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',136,'EXECUTED','9:b7ef76036d3126bb83c2423bf4d449d6','createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-2-not-mysql','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',137,'MARK_RAN','9:23396cf51ab8bc1ae6f0cac7f9f6fcf7','createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-cleanup-css-preload','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',135,'EXECUTED','9:5411d2fb2891d3e8d63ddb55dfa3c0c9','dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-cleanup-uss-by-usersess','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',134,'EXECUTED','9:6eee220d024e38e89c799417ec33667f','dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-cleanup-uss-createdon','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',132,'EXECUTED','9:78ab4fc129ed5e8265dbcc3485fba92f','dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-cleanup-uss-preload','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',133,'EXECUTED','9:de5f7c1f7e10994ed8b62e621d20eaab','dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-index-creation','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',131,'EXECUTED','9:3e96709818458ae49f3c679ae58d263a','createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28265-tables','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',130,'EXECUTED','9:deda2df035df23388af95bbd36c17cef','addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-28861-index-creation','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',142,'EXECUTED','9:b9acb58ac958d9ada0fe12a5d4794ab1','createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET','',NULL,'4.33.0',NULL,NULL,'5919052302'),('25.0.0-org','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',138,'EXECUTED','9:5c859965c2c9b9c72136c360649af157','createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-32583-drop-redundant-index-on-client-session','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',150,'EXECUTED','9:24972d83bf27317a055d234187bb4af9','dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-33201-org-redirect-url','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',152,'EXECUTED','9:4d0e22b0ac68ebe9794fa9cb752ea660','addColumn tableName=ORG','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-idps-for-login','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',149,'EXECUTED','9:51f5fffadf986983d4bd59582c6c1604','addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-org-alias','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',143,'EXECUTED','9:6ef7d63e4412b3c2d66ed179159886a4','addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-org-group','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',144,'EXECUTED','9:da8e8087d80ef2ace4f89d8c5b9ca223','addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-org-group-membership','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',146,'EXECUTED','9:a6ace2ce583a421d89b01ba2a28dc2d4','addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0-org-indexes','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',145,'EXECUTED','9:79b05dcd610a8c7f25ec05135eec0857','createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',151,'EXECUTED','9:febdc0f47f2ed241c59e60f58c3ceea5','dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.1.0-34013','keycloak','META-INF/jpa-changelog-26.1.0.xml','2025-12-16 21:04:28',154,'EXECUTED','9:e6b686a15759aef99a6d758a5c4c6a26','addColumn tableName=ADMIN_EVENT_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.1.0-34380','keycloak','META-INF/jpa-changelog-26.1.0.xml','2025-12-16 21:04:28',155,'EXECUTED','9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01','dropTable tableName=USERNAME_LOGIN_FAILURE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.2.0-26106','keycloak','META-INF/jpa-changelog-26.2.0.xml','2025-12-16 21:04:28',157,'EXECUTED','9:b5877d5dab7d10ff3a9d209d7beb6680','addColumn tableName=CREDENTIAL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.2.0-36750','keycloak','META-INF/jpa-changelog-26.2.0.xml','2025-12-16 21:04:28',156,'EXECUTED','9:b49ce951c22f7eb16480ff085640a33a','createTable tableName=SERVER_CONFIG','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.2.6-39866-duplicate','keycloak','META-INF/jpa-changelog-26.2.6.xml','2025-12-16 21:04:28',158,'EXECUTED','9:1dc67ccee24f30331db2cba4f372e40e','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.2.6-39866-uk','keycloak','META-INF/jpa-changelog-26.2.6.xml','2025-12-16 21:04:28',159,'EXECUTED','9:b70b76f47210cf0a5f4ef0e219eac7cd','addUniqueConstraint constraintName=UK_MIGRATION_VERSION, tableName=MIGRATION_MODEL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.2.6-40088-duplicate','keycloak','META-INF/jpa-changelog-26.2.6.xml','2025-12-16 21:04:28',160,'EXECUTED','9:cc7e02ed69ab31979afb1982f9670e8f','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.2.6-40088-uk','keycloak','META-INF/jpa-changelog-26.2.6.xml','2025-12-16 21:04:28',161,'EXECUTED','9:5bb848128da7bc4595cc507383325241','addUniqueConstraint constraintName=UK_MIGRATION_UPDATE_TIME, tableName=MIGRATION_MODEL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.3.0-groups-description','keycloak','META-INF/jpa-changelog-26.3.0.xml','2025-12-16 21:04:28',162,'EXECUTED','9:e1a3c05574326fb5b246b73b9a4c4d49','addColumn tableName=KEYCLOAK_GROUP','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.4.0-40933-saml-encryption-attributes','keycloak','META-INF/jpa-changelog-26.4.0.xml','2025-12-16 21:04:28',163,'EXECUTED','9:7e9eaba362ca105efdda202303a4fe49','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.4.0-51321','keycloak','META-INF/jpa-changelog-26.4.0.xml','2025-12-16 21:04:28',164,'EXECUTED','9:34bab2bc56f75ffd7e347c580874e306','createIndex indexName=IDX_EVENT_ENTITY_USER_ID_TYPE, tableName=EVENT_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('26.5.0-index-offline-css-by-client','keycloak','META-INF/jpa-changelog-26.5.0.xml','2025-12-26 12:41:50',166,'EXECUTED','9:680b59ca7854fa5b77a303301bb2a941','createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT, tableName=OFFLINE_CLIENT_SESSION','',NULL,'4.33.0',NULL,NULL,'6752908076'),('26.5.0-index-offline-css-by-client-storage-provider','keycloak','META-INF/jpa-changelog-26.5.0.xml','2025-12-26 12:41:50',167,'EXECUTED','9:809bc160e2bc92f9c28eea39db323ae2','createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_STORAGE_PROVIDER, tableName=OFFLINE_CLIENT_SESSION','',NULL,'4.33.0',NULL,NULL,'6752908076'),('29399-jdbc-ping-default','keycloak','META-INF/jpa-changelog-26.1.0.xml','2025-12-16 21:04:28',153,'EXECUTED','9:007dbe99d7203fca403b89d4edfdf21e','createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.0.0','bburke@redhat.com','META-INF/jpa-changelog-3.0.0.xml','2025-12-16 21:04:22',39,'EXECUTED','9:132a67499ba24bcc54fb5cbdcfe7e4c0','addColumn tableName=IDENTITY_PROVIDER','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.2.0-fix','keycloak','META-INF/jpa-changelog-3.2.0.xml','2025-12-16 21:04:22',40,'MARK_RAN','9:938f894c032f5430f2b0fafb1a243462','addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.2.0-fix-offline-sessions','hmlnarik','META-INF/jpa-changelog-3.2.0.xml','2025-12-16 21:04:22',42,'EXECUTED','9:fc86359c079781adc577c5a217e4d04c','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.2.0-fix-with-keycloak-5416','keycloak','META-INF/jpa-changelog-3.2.0.xml','2025-12-16 21:04:22',41,'MARK_RAN','9:845c332ff1874dc5d35974b0babf3006','dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.2.0-fixed','keycloak','META-INF/jpa-changelog-3.2.0.xml','2025-12-16 21:04:23',43,'EXECUTED','9:59a64800e3c0d09b825f8a3b444fa8f4','addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.3.0','keycloak','META-INF/jpa-changelog-3.3.0.xml','2025-12-16 21:04:23',44,'EXECUTED','9:d48d6da5c6ccf667807f633fe489ce88','addColumn tableName=USER_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.4.0','keycloak','META-INF/jpa-changelog-3.4.0.xml','2025-12-16 21:04:24',50,'EXECUTED','9:cfdd8736332ccdd72c5256ccb42335db','addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.4.0-KEYCLOAK-5230','hmlnarik@redhat.com','META-INF/jpa-changelog-3.4.0.xml','2025-12-16 21:04:24',51,'EXECUTED','9:7c84de3d9bd84d7f077607c1a4dcb714','createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.4.1','psilva@redhat.com','META-INF/jpa-changelog-3.4.1.xml','2025-12-16 21:04:24',52,'EXECUTED','9:5a6bb36cbefb6a9d6928452c0852af2d','modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.4.2','keycloak','META-INF/jpa-changelog-3.4.2.xml','2025-12-16 21:04:24',53,'EXECUTED','9:8f23e334dbc59f82e0a328373ca6ced0','update tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('3.4.2-KEYCLOAK-5172','mkanis@redhat.com','META-INF/jpa-changelog-3.4.2.xml','2025-12-16 21:04:24',54,'EXECUTED','9:9156214268f09d970cdf0e1564d866af','update tableName=CLIENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('31296-persist-revoked-access-tokens','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',147,'EXECUTED','9:64ef94489d42a358e8304b0e245f0ed4','createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN','',NULL,'4.33.0',NULL,NULL,'5919052302'),('31725-index-persist-revoked-access-tokens','keycloak','META-INF/jpa-changelog-26.0.0.xml','2025-12-16 21:04:28',148,'EXECUTED','9:b994246ec2bf7c94da881e1d28782c7b','createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.0.0-CLEANUP-UNUSED-TABLE','bburke@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2025-12-16 21:04:24',56,'EXECUTED','9:229a041fb72d5beac76bb94a5fa709de','dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.0.0-KEYCLOAK-5579-fixed','mposolda@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2025-12-16 21:04:25',58,'EXECUTED','9:139b79bcbbfe903bb1c2d2a4dbf001d9','dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.0.0-KEYCLOAK-6228','bburke@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2025-12-16 21:04:24',57,'EXECUTED','9:079899dade9c1e683f26b2aa9ca6ff04','dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.0.0-KEYCLOAK-6335','bburke@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2025-12-16 21:04:24',55,'EXECUTED','9:db806613b1ed154826c02610b7dbdf74','createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.2.0-KEYCLOAK-6313','wadahiro@gmail.com','META-INF/jpa-changelog-4.2.0.xml','2025-12-16 21:04:26',63,'EXECUTED','9:92143a6daea0a3f3b8f598c97ce55c3d','addColumn tableName=REQUIRED_ACTION_PROVIDER','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.3.0-KEYCLOAK-7984','wadahiro@gmail.com','META-INF/jpa-changelog-4.3.0.xml','2025-12-16 21:04:26',64,'EXECUTED','9:82bab26a27195d889fb0429003b18f40','update tableName=REQUIRED_ACTION_PROVIDER','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.6.0-KEYCLOAK-7950','psilva@redhat.com','META-INF/jpa-changelog-4.6.0.xml','2025-12-16 21:04:26',65,'EXECUTED','9:e590c88ddc0b38b0ae4249bbfcb5abc3','update tableName=RESOURCE_SERVER_RESOURCE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.6.0-KEYCLOAK-8377','keycloak','META-INF/jpa-changelog-4.6.0.xml','2025-12-16 21:04:26',66,'EXECUTED','9:5c1f475536118dbdc38d5d7977950cc0','createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.6.0-KEYCLOAK-8555','gideonray@gmail.com','META-INF/jpa-changelog-4.6.0.xml','2025-12-16 21:04:26',67,'EXECUTED','9:e7c9f5f9c4d67ccbbcc215440c718a17','createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.7.0-KEYCLOAK-1267','sguilhen@redhat.com','META-INF/jpa-changelog-4.7.0.xml','2025-12-16 21:04:26',68,'EXECUTED','9:88e0bfdda924690d6f4e430c53447dd5','addColumn tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.7.0-KEYCLOAK-7275','keycloak','META-INF/jpa-changelog-4.7.0.xml','2025-12-16 21:04:26',69,'EXECUTED','9:f53177f137e1c46b6a88c59ec1cb5218','renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('4.8.0-KEYCLOAK-8835','sguilhen@redhat.com','META-INF/jpa-changelog-4.8.0.xml','2025-12-16 21:04:26',70,'EXECUTED','9:a74d33da4dc42a37ec27121580d1459f','addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('40343-workflow-state-table','keycloak','META-INF/jpa-changelog-26.4.0.xml','2025-12-16 21:04:28',165,'EXECUTED','9:ed3ab4723ceed210e5b5e60ac4562106','createTable tableName=WORKFLOW_STATE; addPrimaryKey constraintName=PK_WORKFLOW_STATE, tableName=WORKFLOW_STATE; addUniqueConstraint constraintName=UQ_WORKFLOW_RESOURCE, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_STEP, table...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('8.0.0-adding-credential-columns','keycloak','META-INF/jpa-changelog-8.0.0.xml','2025-12-16 21:04:26',72,'EXECUTED','9:aa072ad090bbba210d8f18781b8cebf4','addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('8.0.0-credential-cleanup-fixed','keycloak','META-INF/jpa-changelog-8.0.0.xml','2025-12-16 21:04:26',75,'EXECUTED','9:2b9cc12779be32c5b40e2e67711a218b','dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('8.0.0-resource-tag-support','keycloak','META-INF/jpa-changelog-8.0.0.xml','2025-12-16 21:04:26',76,'EXECUTED','9:91fa186ce7a5af127a2d7a91ee083cc5','addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('8.0.0-updating-credential-data-not-oracle-fixed','keycloak','META-INF/jpa-changelog-8.0.0.xml','2025-12-16 21:04:26',73,'EXECUTED','9:1ae6be29bab7c2aa376f6983b932be37','update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('8.0.0-updating-credential-data-oracle-fixed','keycloak','META-INF/jpa-changelog-8.0.0.xml','2025-12-16 21:04:26',74,'MARK_RAN','9:14706f286953fc9a25286dbd8fb30d97','update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.0-always-display-client','keycloak','META-INF/jpa-changelog-9.0.0.xml','2025-12-16 21:04:26',77,'EXECUTED','9:6335e5c94e83a2639ccd68dd24e2e5ad','addColumn tableName=CLIENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.0-drop-constraints-for-column-increase','keycloak','META-INF/jpa-changelog-9.0.0.xml','2025-12-16 21:04:26',78,'MARK_RAN','9:6bdb5658951e028bfe16fa0a8228b530','dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.0-increase-column-size-federated-fk','keycloak','META-INF/jpa-changelog-9.0.0.xml','2025-12-16 21:04:27',79,'EXECUTED','9:d5bc15a64117ccad481ce8792d4c608f','modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.0-recreate-constraints-after-column-increase','keycloak','META-INF/jpa-changelog-9.0.0.xml','2025-12-16 21:04:27',80,'MARK_RAN','9:077cba51999515f4d3e7ad5619ab592c','addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.1-add-index-to-client.client_id','keycloak','META-INF/jpa-changelog-9.0.1.xml','2025-12-16 21:04:27',81,'EXECUTED','9:be969f08a163bf47c6b9e9ead8ac2afb','createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.1-add-index-to-events','keycloak','META-INF/jpa-changelog-9.0.1.xml','2025-12-16 21:04:27',85,'EXECUTED','9:7d93d602352a30c0c317e6a609b56599','createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.1-KEYCLOAK-12579-add-not-null-constraint','keycloak','META-INF/jpa-changelog-9.0.1.xml','2025-12-16 21:04:27',83,'EXECUTED','9:966bda61e46bebf3cc39518fbed52fa7','addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.1-KEYCLOAK-12579-drop-constraints','keycloak','META-INF/jpa-changelog-9.0.1.xml','2025-12-16 21:04:27',82,'MARK_RAN','9:6d3bb4408ba5a72f39bd8a0b301ec6e3','dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP','',NULL,'4.33.0',NULL,NULL,'5919052302'),('9.0.1-KEYCLOAK-12579-recreate-constraints','keycloak','META-INF/jpa-changelog-9.0.1.xml','2025-12-16 21:04:27',84,'MARK_RAN','9:8dcac7bdf7378e7d823cdfddebf72fda','addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authn-3.4.0.CR1-refresh-token-max-reuse','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2025-12-16 21:04:24',49,'EXECUTED','9:d198654156881c46bfba39abd7769e69','addColumn tableName=REALM','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-2.0.0','psilva@redhat.com','META-INF/jpa-changelog-authz-2.0.0.xml','2025-12-16 21:04:21',27,'EXECUTED','9:43ed6b0da89ff77206289e87eaa9c024','createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-2.5.1','psilva@redhat.com','META-INF/jpa-changelog-authz-2.5.1.xml','2025-12-16 21:04:21',28,'EXECUTED','9:44bae577f551b3738740281eceb4ea70','update tableName=RESOURCE_SERVER_POLICY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-3.4.0.CR1-resource-server-pk-change-part1','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2025-12-16 21:04:23',45,'EXECUTED','9:dde36f7973e80d71fceee683bc5d2951','addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095','hmlnarik@redhat.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2025-12-16 21:04:23',46,'EXECUTED','9:b855e9b0a406b34fa323235a0cf4f640','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-3.4.0.CR1-resource-server-pk-change-part3-fixed','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2025-12-16 21:04:23',47,'MARK_RAN','9:51abbacd7b416c50c4421a8cabf7927e','dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2025-12-16 21:04:24',48,'EXECUTED','9:bdc99e567b3398bac83263d375aad143','addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-4.0.0.Beta3','psilva@redhat.com','META-INF/jpa-changelog-authz-4.0.0.Beta3.xml','2025-12-16 21:04:26',60,'EXECUTED','9:e0057eac39aa8fc8e09ac6cfa4ae15fe','addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-4.0.0.CR1','psilva@redhat.com','META-INF/jpa-changelog-authz-4.0.0.CR1.xml','2025-12-16 21:04:26',59,'EXECUTED','9:b55738ad889860c625ba2bf483495a04','createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-4.2.0.Final','mhajas@redhat.com','META-INF/jpa-changelog-authz-4.2.0.Final.xml','2025-12-16 21:04:26',61,'EXECUTED','9:42a33806f3a0443fe0e7feeec821326c','createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-4.2.0.Final-KEYCLOAK-9944','hmlnarik@redhat.com','META-INF/jpa-changelog-authz-4.2.0.Final.xml','2025-12-16 21:04:26',62,'EXECUTED','9:9968206fca46eecc1f51db9c024bfe56','addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS','',NULL,'4.33.0',NULL,NULL,'5919052302'),('authz-7.0.0-KEYCLOAK-10443','psilva@redhat.com','META-INF/jpa-changelog-authz-7.0.0.xml','2025-12-16 21:04:26',71,'EXECUTED','9:fd4ade7b90c3b67fae0bfcfcb42dfb5f','addColumn tableName=RESOURCE_SERVER','',NULL,'4.33.0',NULL,NULL,'5919052302'),('client-attributes-string-accomodation-fixed','keycloak','META-INF/jpa-changelog-20.0.0.xml','2025-12-16 21:04:27',113,'EXECUTED','9:3f332e13e90739ed0c35b0b25b7822ca','addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('client-attributes-string-accomodation-fixed-post-create-index','keycloak','META-INF/jpa-changelog-20.0.0.xml','2025-12-16 21:04:27',114,'MARK_RAN','9:bd2bd0fc7768cf0845ac96a8786fa735','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('client-attributes-string-accomodation-fixed-pre-drop-index','keycloak','META-INF/jpa-changelog-20.0.0.xml','2025-12-16 21:04:27',112,'EXECUTED','9:04baaf56c116ed19951cbc2cca584022','dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('default-roles','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',89,'EXECUTED','9:fa8a5b5445e3857f4b010bafb5009957','addColumn tableName=REALM; customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('default-roles-cleanup','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',90,'EXECUTED','9:67ac3241df9a8582d591c5ed87125f39','dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES','',NULL,'4.33.0',NULL,NULL,'5919052302'),('json-string-accomodation-fixed','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',96,'EXECUTED','9:e07d2bc0970c348bb06fb63b1f82ddbf','addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('KEYCLOAK-17267-add-index-to-user-attributes','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',102,'EXECUTED','9:0b305d8d1277f3a89a0a53a659ad274c','createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE','',NULL,'4.33.0',NULL,NULL,'5919052302'),('KEYCLOAK-18146-add-saml-art-binding-identifier','keycloak','META-INF/jpa-changelog-14.0.0.xml','2025-12-16 21:04:27',103,'EXECUTED','9:2c374ad2cdfe20e2905a84c8fac48460','customChange','',NULL,'4.33.0',NULL,NULL,'5919052302'),('map-remove-ri','keycloak','META-INF/jpa-changelog-11.0.0.xml','2025-12-16 21:04:27',86,'EXECUTED','9:71c5969e6cdd8d7b6f47cebc86d37627','dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9','',NULL,'4.33.0',NULL,NULL,'5919052302'),('map-remove-ri','keycloak','META-INF/jpa-changelog-12.0.0.xml','2025-12-16 21:04:27',87,'EXECUTED','9:a9ba7d47f065f041b7da856a81762021','dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('map-remove-ri-13.0.0','keycloak','META-INF/jpa-changelog-13.0.0.xml','2025-12-16 21:04:27',92,'EXECUTED','9:d9be619d94af5a2f5d07b9f003543b91','dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('unique-consentuser','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',139,'MARK_RAN','9:5857626a2ea8767e9a6c66bf3a2cb32f','customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('unique-consentuser-edb-migration','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',140,'MARK_RAN','9:5857626a2ea8767e9a6c66bf3a2cb32f','customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...','',NULL,'4.33.0',NULL,NULL,'5919052302'),('unique-consentuser-mysql','keycloak','META-INF/jpa-changelog-25.0.0.xml','2025-12-16 21:04:28',141,'EXECUTED','9:b79478aad5adaa1bc428e31563f55e8e','customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...','',NULL,'4.33.0',NULL,NULL,'5919052302');
/*!40000 ALTER TABLE `DATABASECHANGELOG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATABASECHANGELOGLOCK`
--

DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` tinyint NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASECHANGELOGLOCK`
--

LOCK TABLES `DATABASECHANGELOGLOCK` WRITE;
/*!40000 ALTER TABLE `DATABASECHANGELOGLOCK` DISABLE KEYS */;
INSERT INTO `DATABASECHANGELOGLOCK` (`ID`, `LOCKED`, `LOCKGRANTED`, `LOCKEDBY`) VALUES (1,0,NULL,NULL),(1000,0,NULL,NULL);
/*!40000 ALTER TABLE `DATABASECHANGELOGLOCK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DEFAULT_CLIENT_SCOPE`
--

DROP TABLE IF EXISTS `DEFAULT_CLIENT_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DEFAULT_CLIENT_SCOPE` (
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DEFAULT_SCOPE` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`REALM_ID`,`SCOPE_ID`),
  KEY `IDX_DEFCLS_REALM` (`REALM_ID`),
  KEY `IDX_DEFCLS_SCOPE` (`SCOPE_ID`),
  CONSTRAINT `FK_R_DEF_CLI_SCOPE_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DEFAULT_CLIENT_SCOPE`
--

LOCK TABLES `DEFAULT_CLIENT_SCOPE` WRITE;
/*!40000 ALTER TABLE `DEFAULT_CLIENT_SCOPE` DISABLE KEYS */;
INSERT INTO `DEFAULT_CLIENT_SCOPE` (`REALM_ID`, `SCOPE_ID`, `DEFAULT_SCOPE`) VALUES ('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','28384917-02ed-4cff-b623-7b07312e6957',0),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','2a71c4c4-6670-4109-a418-7cad37eae11f',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','4a4f1740-3ff8-4d0a-b393-a080cfe5eab6',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','93895050-1420-4db0-89cf-1646b1c24662',0),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','a9c6cbeb-1e10-475c-a89e-3ba7c669468f',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','b0db2e23-0e7d-4738-bbd2-c3df4d2325f0',0),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','b108748b-23a0-430a-9921-c1f1fcbe3548',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab',0),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','e9aa4630-2911-4e04-bc19-b3bcf1a6083a',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','eab91a8c-7bf3-4217-8a44-28fa150ec6ab',1),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','f03c0dde-12e1-4771-a74e-6f6515c2ecf3',0),('c873670d-8167-4205-af33-8519fdff5955','0dce6a7b-00e3-46f7-91ce-0ebab2c4cb40',1),('c873670d-8167-4205-af33-8519fdff5955','1525a54b-4819-4ec1-b7a5-a4fd59b46a87',0),('c873670d-8167-4205-af33-8519fdff5955','18acd87e-defa-442c-9f22-17de31d3e6c6',1),('c873670d-8167-4205-af33-8519fdff5955','21f57746-bd06-4754-98dc-5d5644197a1c',0),('c873670d-8167-4205-af33-8519fdff5955','229b3874-96b9-4b24-86be-1c77178fecbf',1),('c873670d-8167-4205-af33-8519fdff5955','41e52320-5f02-405b-b573-57e05efff200',0),('c873670d-8167-4205-af33-8519fdff5955','492a67dc-ab1a-411b-8aff-5a1e8f4c9153',1),('c873670d-8167-4205-af33-8519fdff5955','6b58bdf3-ba9e-4138-98cc-2adfe96a84b1',1),('c873670d-8167-4205-af33-8519fdff5955','74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50',1),('c873670d-8167-4205-af33-8519fdff5955','a743a1b7-0c2a-4574-9cea-705a924a771b',0),('c873670d-8167-4205-af33-8519fdff5955','cf90ce90-377b-426c-bd98-b92acd4e85f3',0),('c873670d-8167-4205-af33-8519fdff5955','e541d53a-0702-4352-a8db-1f21c3f32577',1),('c873670d-8167-4205-af33-8519fdff5955','ef0b0964-0624-4733-8b8e-688a1db399db',1);
/*!40000 ALTER TABLE `DEFAULT_CLIENT_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EVENT_ENTITY`
--

DROP TABLE IF EXISTS `EVENT_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EVENT_ENTITY` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DETAILS_JSON` text COLLATE utf8mb4_unicode_ci,
  `ERROR` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ADDRESS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SESSION_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EVENT_TIME` bigint DEFAULT NULL,
  `TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DETAILS_JSON_LONG_VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`ID`),
  KEY `IDX_EVENT_TIME` (`REALM_ID`,`EVENT_TIME`),
  KEY `IDX_EVENT_ENTITY_USER_ID_TYPE` (`USER_ID`,`TYPE`,`EVENT_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EVENT_ENTITY`
--

LOCK TABLES `EVENT_ENTITY` WRITE;
/*!40000 ALTER TABLE `EVENT_ENTITY` DISABLE KEYS */;
/*!40000 ALTER TABLE `EVENT_ENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FEDERATED_IDENTITY`
--

DROP TABLE IF EXISTS `FEDERATED_IDENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FEDERATED_IDENTITY` (
  `IDENTITY_PROVIDER` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FEDERATED_USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FEDERATED_USERNAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TOKEN` text COLLATE utf8mb4_unicode_ci,
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`IDENTITY_PROVIDER`,`USER_ID`),
  KEY `IDX_FEDIDENTITY_USER` (`USER_ID`),
  KEY `IDX_FEDIDENTITY_FEDUSER` (`FEDERATED_USER_ID`),
  CONSTRAINT `FK404288B92EF007A6` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FEDERATED_IDENTITY`
--

LOCK TABLES `FEDERATED_IDENTITY` WRITE;
/*!40000 ALTER TABLE `FEDERATED_IDENTITY` DISABLE KEYS */;
/*!40000 ALTER TABLE `FEDERATED_IDENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FEDERATED_USER`
--

DROP TABLE IF EXISTS `FEDERATED_USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FEDERATED_USER` (
  `ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FEDERATED_USER`
--

LOCK TABLES `FEDERATED_USER` WRITE;
/*!40000 ALTER TABLE `FEDERATED_USER` DISABLE KEYS */;
/*!40000 ALTER TABLE `FEDERATED_USER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_ATTRIBUTE`
--

DROP TABLE IF EXISTS `FED_USER_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_ATTRIBUTE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VALUE` text COLLATE utf8mb4_unicode_ci,
  `LONG_VALUE_HASH` binary(64) DEFAULT NULL,
  `LONG_VALUE_HASH_LOWER_CASE` binary(64) DEFAULT NULL,
  `LONG_VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`ID`),
  KEY `IDX_FU_ATTRIBUTE` (`USER_ID`,`REALM_ID`,`NAME`),
  KEY `FED_USER_ATTR_LONG_VALUES` (`LONG_VALUE_HASH`,`NAME`),
  KEY `FED_USER_ATTR_LONG_VALUES_LOWER_CASE` (`LONG_VALUE_HASH_LOWER_CASE`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_ATTRIBUTE`
--

LOCK TABLES `FED_USER_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `FED_USER_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_CONSENT`
--

DROP TABLE IF EXISTS `FED_USER_CONSENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_CONSENT` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `LAST_UPDATED_DATE` bigint DEFAULT NULL,
  `CLIENT_STORAGE_PROVIDER` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EXTERNAL_CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_FU_CONSENT` (`USER_ID`,`CLIENT_ID`),
  KEY `IDX_FU_CONSENT_RU` (`REALM_ID`,`USER_ID`),
  KEY `IDX_FU_CNSNT_EXT` (`USER_ID`,`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_CONSENT`
--

LOCK TABLES `FED_USER_CONSENT` WRITE;
/*!40000 ALTER TABLE `FED_USER_CONSENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_CONSENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_CONSENT_CL_SCOPE`
--

DROP TABLE IF EXISTS `FED_USER_CONSENT_CL_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_CONSENT_CL_SCOPE` (
  `USER_CONSENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`USER_CONSENT_ID`,`SCOPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_CONSENT_CL_SCOPE`
--

LOCK TABLES `FED_USER_CONSENT_CL_SCOPE` WRITE;
/*!40000 ALTER TABLE `FED_USER_CONSENT_CL_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_CONSENT_CL_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_CREDENTIAL`
--

DROP TABLE IF EXISTS `FED_USER_CREDENTIAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_CREDENTIAL` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SALT` tinyblob,
  `TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_LABEL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SECRET_DATA` longtext COLLATE utf8mb4_unicode_ci,
  `CREDENTIAL_DATA` longtext COLLATE utf8mb4_unicode_ci,
  `PRIORITY` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_FU_CREDENTIAL` (`USER_ID`,`TYPE`),
  KEY `IDX_FU_CREDENTIAL_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_CREDENTIAL`
--

LOCK TABLES `FED_USER_CREDENTIAL` WRITE;
/*!40000 ALTER TABLE `FED_USER_CREDENTIAL` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_CREDENTIAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_GROUP_MEMBERSHIP`
--

DROP TABLE IF EXISTS `FED_USER_GROUP_MEMBERSHIP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_GROUP_MEMBERSHIP` (
  `GROUP_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`,`USER_ID`),
  KEY `IDX_FU_GROUP_MEMBERSHIP` (`USER_ID`,`GROUP_ID`),
  KEY `IDX_FU_GROUP_MEMBERSHIP_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_GROUP_MEMBERSHIP`
--

LOCK TABLES `FED_USER_GROUP_MEMBERSHIP` WRITE;
/*!40000 ALTER TABLE `FED_USER_GROUP_MEMBERSHIP` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_GROUP_MEMBERSHIP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_REQUIRED_ACTION`
--

DROP TABLE IF EXISTS `FED_USER_REQUIRED_ACTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_REQUIRED_ACTION` (
  `REQUIRED_ACTION` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ' ',
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`REQUIRED_ACTION`,`USER_ID`),
  KEY `IDX_FU_REQUIRED_ACTION` (`USER_ID`,`REQUIRED_ACTION`),
  KEY `IDX_FU_REQUIRED_ACTION_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_REQUIRED_ACTION`
--

LOCK TABLES `FED_USER_REQUIRED_ACTION` WRITE;
/*!40000 ALTER TABLE `FED_USER_REQUIRED_ACTION` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_REQUIRED_ACTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `FED_USER_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_ROLE_MAPPING` (
  `ROLE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ROLE_ID`,`USER_ID`),
  KEY `IDX_FU_ROLE_MAPPING` (`USER_ID`,`ROLE_ID`),
  KEY `IDX_FU_ROLE_MAPPING_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_ROLE_MAPPING`
--

LOCK TABLES `FED_USER_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `FED_USER_ROLE_MAPPING` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GROUP_ATTRIBUTE`
--

DROP TABLE IF EXISTS `GROUP_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GROUP_ATTRIBUTE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sybase-needs-something-here',
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GROUP_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_GROUP_ATTR_GROUP` (`GROUP_ID`),
  KEY `IDX_GROUP_ATT_BY_NAME_VALUE` (`NAME`,`VALUE`),
  CONSTRAINT `FK_GROUP_ATTRIBUTE_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `KEYCLOAK_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GROUP_ATTRIBUTE`
--

LOCK TABLES `GROUP_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `GROUP_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `GROUP_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GROUP_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `GROUP_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GROUP_ROLE_MAPPING` (
  `ROLE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `GROUP_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`GROUP_ID`),
  KEY `IDX_GROUP_ROLE_MAPP_GROUP` (`GROUP_ID`),
  CONSTRAINT `FK_GROUP_ROLE_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `KEYCLOAK_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GROUP_ROLE_MAPPING`
--

LOCK TABLES `GROUP_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `GROUP_ROLE_MAPPING` DISABLE KEYS */;
/*!40000 ALTER TABLE `GROUP_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDENTITY_PROVIDER`
--

DROP TABLE IF EXISTS `IDENTITY_PROVIDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDENTITY_PROVIDER` (
  `INTERNAL_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ENABLED` tinyint NOT NULL DEFAULT '0',
  `PROVIDER_ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROVIDER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STORE_TOKEN` tinyint NOT NULL DEFAULT '0',
  `AUTHENTICATE_BY_DEFAULT` tinyint NOT NULL DEFAULT '0',
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ADD_TOKEN_ROLE` tinyint NOT NULL DEFAULT '1',
  `TRUST_EMAIL` tinyint NOT NULL DEFAULT '0',
  `FIRST_BROKER_LOGIN_FLOW_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `POST_BROKER_LOGIN_FLOW_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROVIDER_DISPLAY_NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LINK_ONLY` tinyint NOT NULL DEFAULT '0',
  `ORGANIZATION_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HIDE_ON_LOGIN` tinyint DEFAULT '0',
  PRIMARY KEY (`INTERNAL_ID`),
  UNIQUE KEY `UK_2DAELWNIBJI49AVXSRTUF6XJ33` (`PROVIDER_ALIAS`,`REALM_ID`),
  KEY `IDX_IDENT_PROV_REALM` (`REALM_ID`),
  KEY `IDX_IDP_REALM_ORG` (`REALM_ID`,`ORGANIZATION_ID`),
  KEY `IDX_IDP_FOR_LOGIN` (`REALM_ID`,`ENABLED`,`LINK_ONLY`,`HIDE_ON_LOGIN`,`ORGANIZATION_ID`),
  CONSTRAINT `FK2B4EBC52AE5C3B34` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDENTITY_PROVIDER`
--

LOCK TABLES `IDENTITY_PROVIDER` WRITE;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDENTITY_PROVIDER_CONFIG`
--

DROP TABLE IF EXISTS `IDENTITY_PROVIDER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDENTITY_PROVIDER_CONFIG` (
  `IDENTITY_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`IDENTITY_PROVIDER_ID`,`NAME`),
  CONSTRAINT `FKDC4897CF864C4E43` FOREIGN KEY (`IDENTITY_PROVIDER_ID`) REFERENCES `IDENTITY_PROVIDER` (`INTERNAL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDENTITY_PROVIDER_CONFIG`
--

LOCK TABLES `IDENTITY_PROVIDER_CONFIG` WRITE;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDENTITY_PROVIDER_MAPPER`
--

DROP TABLE IF EXISTS `IDENTITY_PROVIDER_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDENTITY_PROVIDER_MAPPER` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IDP_ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IDP_MAPPER_NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_ID_PROV_MAPP_REALM` (`REALM_ID`),
  CONSTRAINT `FK_IDPM_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDENTITY_PROVIDER_MAPPER`
--

LOCK TABLES `IDENTITY_PROVIDER_MAPPER` WRITE;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_MAPPER` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDP_MAPPER_CONFIG`
--

DROP TABLE IF EXISTS `IDP_MAPPER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDP_MAPPER_CONFIG` (
  `IDP_MAPPER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`IDP_MAPPER_ID`,`NAME`),
  CONSTRAINT `FK_IDPMCONFIG` FOREIGN KEY (`IDP_MAPPER_ID`) REFERENCES `IDENTITY_PROVIDER_MAPPER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDP_MAPPER_CONFIG`
--

LOCK TABLES `IDP_MAPPER_CONFIG` WRITE;
/*!40000 ALTER TABLE `IDP_MAPPER_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDP_MAPPER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `JGROUPS_PING`
--

DROP TABLE IF EXISTS `JGROUPS_PING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `JGROUPS_PING` (
  `address` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cluster_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `coord` tinyint DEFAULT NULL,
  PRIMARY KEY (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JGROUPS_PING`
--

LOCK TABLES `JGROUPS_PING` WRITE;
/*!40000 ALTER TABLE `JGROUPS_PING` DISABLE KEYS */;
INSERT INTO `JGROUPS_PING` (`address`, `name`, `cluster_name`, `ip`, `coord`) VALUES ('uuid://00000000-0000-0000-0000-00000000005f','de8115f12aa4-35227','ISPN','172.23.0.2:7800',1);
/*!40000 ALTER TABLE `JGROUPS_PING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KEYCLOAK_GROUP`
--

DROP TABLE IF EXISTS `KEYCLOAK_GROUP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KEYCLOAK_GROUP` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_GROUP` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` int NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SIBLING_NAMES` (`REALM_ID`,`PARENT_GROUP`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KEYCLOAK_GROUP`
--

LOCK TABLES `KEYCLOAK_GROUP` WRITE;
/*!40000 ALTER TABLE `KEYCLOAK_GROUP` DISABLE KEYS */;
/*!40000 ALTER TABLE `KEYCLOAK_GROUP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KEYCLOAK_ROLE`
--

DROP TABLE IF EXISTS `KEYCLOAK_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KEYCLOAK_ROLE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CLIENT_REALM_CONSTRAINT` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CLIENT_ROLE` tinyint DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CLIENT` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_J3RWUVD56ONTGSUHOGM184WW2-2` (`NAME`,`CLIENT_REALM_CONSTRAINT`),
  KEY `IDX_KEYCLOAK_ROLE_CLIENT` (`CLIENT`),
  KEY `IDX_KEYCLOAK_ROLE_REALM` (`REALM`),
  CONSTRAINT `FK_6VYQFE4CN4WLQ8R6KT5VDSJ5C` FOREIGN KEY (`REALM`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KEYCLOAK_ROLE`
--

LOCK TABLES `KEYCLOAK_ROLE` WRITE;
/*!40000 ALTER TABLE `KEYCLOAK_ROLE` DISABLE KEYS */;
INSERT INTO `KEYCLOAK_ROLE` (`ID`, `CLIENT_REALM_CONSTRAINT`, `CLIENT_ROLE`, `DESCRIPTION`, `NAME`, `REALM_ID`, `CLIENT`, `REALM`) VALUES ('026c9e72-b023-465c-bf75-bdc8516b26c6','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_view-events}','view-events','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('09db3cfc-a054-4e96-82b4-265054497be8','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_view-users}','view-users','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('0be0f161-0bfa-4df1-b7b0-c83a1c88ec75','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_manage-account}','manage-account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('0d08b3cc-c18b-4d64-866b-07eab8f6a7b7','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_view-realm}','view-realm','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('0f682252-2190-4bdf-a65e-1c9cc5d1a130','c873670d-8167-4205-af33-8519fdff5955',0,'${role_default-roles}','default-roles-master','c873670d-8167-4205-af33-8519fdff5955',NULL,NULL),('10fc5f89-ed70-4bd5-834c-6fe55da79eb9','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_view-identity-providers}','view-identity-providers','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('14ee911d-3e03-4aab-8caa-a313db1795f3','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_view-users}','view-users','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('1cc06174-b1b7-477c-8491-be1481b24dc3','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_manage-realm}','manage-realm','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('1d210159-4c61-465c-9708-08bf2f08b44e','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_query-realms}','query-realms','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('21641986-3ae5-4971-8e21-81147a237896','7d330af7-4d9b-4abd-bebc-8562527b8d62',1,'${role_read-token}','read-token','c873670d-8167-4205-af33-8519fdff5955','7d330af7-4d9b-4abd-bebc-8562527b8d62',NULL),('224ea08c-7ece-4c9b-8718-147ed4094b9c','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_manage-realm}','manage-realm','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('23239c07-76bf-4e99-bd63-28350366b303','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_realm-admin}','realm-admin','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('27724851-5224-4b3d-aa0a-c4da122b65b5','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_query-clients}','query-clients','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('27a8d6a5-4cfb-4793-ad02-fb0277599d6b','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_query-users}','query-users','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('31aa74c8-be92-4599-a411-c2e4d0e701ab','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_manage-users}','manage-users','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('358e8af2-c185-4c50-99f2-4965f5f9a96b','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,'${role_uma_authorization}','uma_authorization','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL,NULL),('35cedb35-3ef6-4343-a0fd-61766d82ef4a','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_manage-realm}','manage-realm','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('37868fcb-9b2c-4408-a496-b0c22ea8b916','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_view-groups}','view-groups','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('393a73d2-0ba7-42df-b646-12c1f5585de5','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_manage-events}','manage-events','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('39d99fb9-d8c9-416e-a3ca-ba7481555919','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_delete-account}','delete-account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('3d726bac-5a8f-46bd-9629-7e5c8d180138','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_query-clients}','query-clients','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('3f98208c-06a0-4d22-a3f2-689d2300e576','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_view-profile}','view-profile','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('45f418d3-8867-4f2e-a265-e62497a53c12','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_create-client}','create-client','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('48577b46-6b30-4169-ac2c-85edd8cfc11c','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_manage-identity-providers}','manage-identity-providers','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('4af7faba-58c9-427c-9197-e548ef944941','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_query-users}','query-users','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('4e0868e7-ca25-45be-a018-a8ce2d8aa842','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_manage-consent}','manage-consent','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('517d4f3b-2c0a-4859-858e-e8210273d456','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_impersonation}','impersonation','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('54a22128-248a-4632-bdfb-3462a684a4f3','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_query-realms}','query-realms','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('552eae8b-b7ec-4117-9c6c-57c20b4f54f6','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_view-identity-providers}','view-identity-providers','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('585558bf-1a85-4955-9343-172c7b92ad8f','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_manage-clients}','manage-clients','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('5b2ad3b7-b067-4fbf-9b43-5fd86d3896ab','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_manage-account-links}','manage-account-links','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('5dcce07d-25b0-4a2c-b5a6-e8fa23fc5e66','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_view-users}','view-users','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('61d078d4-1e5c-4326-978c-295428d41c62','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,'${role_offline-access}','offline_access','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL,NULL),('65d829ba-a5c6-4c13-84d6-5d2d57a3920a','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_manage-account-links}','manage-account-links','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('67edcbdd-c6c9-441e-a27f-ea6c7aedffcc','c873670d-8167-4205-af33-8519fdff5955',0,'${role_uma_authorization}','uma_authorization','c873670d-8167-4205-af33-8519fdff5955',NULL,NULL),('68310cb2-f6c3-4949-85c4-c3c76c285dd5','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_view-groups}','view-groups','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('731a8627-3f6c-4a47-847a-18ab45194f00','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_manage-events}','manage-events','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('75ae6bc7-9d48-4be6-b9b5-7a0b6c7f4a61','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_manage-consent}','manage-consent','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('7ca1f358-ef99-4274-a4ff-d33fc146a115','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_query-realms}','query-realms','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('7d02219a-ef97-4500-9c3e-ee6de52bf465','c873670d-8167-4205-af33-8519fdff5955',0,'${role_offline-access}','offline_access','c873670d-8167-4205-af33-8519fdff5955',NULL,NULL),('7d6f7d58-447b-4807-bf0d-e52855574c88','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_manage-users}','manage-users','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('80add76c-f7f2-4bad-ab92-eae1fd77853c','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_query-users}','query-users','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('8572e882-5644-4acc-954d-dbdb7f9a378a','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_view-authorization}','view-authorization','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('87052c65-5102-421e-a477-c8ecc3f7c98a','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_view-authorization}','view-authorization','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('88686a44-1f56-45e9-afec-72f8013c91b4','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_view-consent}','view-consent','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('89102a66-0a55-4ee7-9558-8e6edcd130af','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_query-groups}','query-groups','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('8a33dbd8-cc74-4b3c-aadc-c841b23883e7','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_manage-identity-providers}','manage-identity-providers','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('8c0e76d1-d061-4871-95e2-52df7f44ee8a','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_query-clients}','query-clients','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('8c7d8cde-93d3-42dd-aed4-8002001e61fe','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_view-consent}','view-consent','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('9ebef503-961f-4745-8da6-e9cbdc1caa49','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_manage-authorization}','manage-authorization','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('9f8b76f3-5e25-4c2c-868e-26e9526e54b6','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_delete-account}','delete-account','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('a653c42c-b5ea-40fb-8115-54e4eb8861ec','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_view-clients}','view-clients','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('a675b148-ea75-435d-82c6-24f12ada704d','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_create-client}','create-client','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('a68d0c5c-00a2-4dbf-8c96-a54d1d6d51af','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_view-events}','view-events','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('a934b7f0-714e-4c21-bcf2-c603daa4313c','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_create-client}','create-client','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('a94d1665-92ef-4f2b-9b64-37a83fea21e2','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_manage-authorization}','manage-authorization','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('b3c65021-7052-41a1-b994-bd522a35bcea','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_view-clients}','view-clients','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('b9c9053f-8b22-405f-9f5c-fe26dd836334','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_manage-events}','manage-events','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('ba12455a-29fc-4a9f-88c3-f4df58d641bb','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_manage-account}','manage-account','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('bb2916e1-3e7e-4094-874a-f5b0986267d3','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_view-applications}','view-applications','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('bb400aff-c02a-4b6f-905c-6f0b67c2ca56','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_view-authorization}','view-authorization','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('bc29392a-51f8-4455-9d7a-cc374cbbaf8f','80ea558e-f66c-4b77-bce0-5424629e49bf',1,'${role_view-applications}','view-applications','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','80ea558e-f66c-4b77-bce0-5424629e49bf',NULL),('bd8be41b-0953-4a2d-a536-81bab39e561a','90feb8c2-3439-42bd-8522-fca2f49fb86b',1,'${role_read-token}','read-token','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','90feb8c2-3439-42bd-8522-fca2f49fb86b',NULL),('c2b04256-11f0-48bc-9e00-141b400e27b7','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,'admin flighthours','admin','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL,NULL),('c462468d-0b4a-4c8c-8645-429c52eca1ee','c873670d-8167-4205-af33-8519fdff5955',0,'${role_create-realm}','create-realm','c873670d-8167-4205-af33-8519fdff5955',NULL,NULL),('cd2d8d15-d077-4e3c-b873-ab0327bc93d2','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_view-clients}','view-clients','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,'${role_default-roles}','default-roles-flighthours','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL,NULL),('d7fa4be3-60f4-47e1-ad80-4f37fc4d8053','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_manage-authorization}','manage-authorization','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('dc18ea96-139f-49b2-8465-4ca3fc89b567','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_query-groups}','query-groups','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('ddacf774-0aef-4361-9e41-4b35ac252eea','c873670d-8167-4205-af33-8519fdff5955',0,'${role_admin}','admin','c873670d-8167-4205-af33-8519fdff5955',NULL,NULL),('deb4ef45-876d-4ab5-bcd0-febe09244597','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_query-groups}','query-groups','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('e274a4fc-0b4b-4221-9c90-b7f77c424fcf','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_view-identity-providers}','view-identity-providers','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('e51d0bd7-6abe-4fa6-8c9c-cca14c34275a','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_view-realm}','view-realm','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('e7c320d9-b58f-49d2-9ae9-58fdded3abaa','474ae4f8-f457-4bdc-8188-f31b5c2da25d',1,'${role_view-profile}','view-profile','c873670d-8167-4205-af33-8519fdff5955','474ae4f8-f457-4bdc-8188-f31b5c2da25d',NULL),('ea78137d-26f7-44ac-ac2f-ed65d836f08a','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_impersonation}','impersonation','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('ef363ce7-69c3-43aa-af66-13fa3fbe3358','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_manage-clients}','manage-clients','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('f22df1db-e246-4c6f-983a-2e0bac7f2db6','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_manage-clients}','manage-clients','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('f3aa9cac-9cca-436c-9d06-07ebaa0f77a1','a2ac983e-a7e0-4013-a873-c0abcef7befd',1,'${role_view-events}','view-events','c873670d-8167-4205-af33-8519fdff5955','a2ac983e-a7e0-4013-a873-c0abcef7befd',NULL),('f518b8af-9523-4c26-a507-f69594b78d27','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_manage-identity-providers}','manage-identity-providers','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('f5ca9c99-8f3f-41b0-819a-afaaa960b598','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_impersonation}','impersonation','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('f730dd50-853d-4aaf-b092-119b362f0974','abb55dcc-23ed-448b-8265-bcb91d09c1d3',1,'${role_view-realm}','view-realm','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','abb55dcc-23ed-448b-8265-bcb91d09c1d3',NULL),('ff167167-8fb5-4e88-8e52-4a4c03df9cf6','28d5185c-e40e-4d11-a93d-d54349888289',1,'${role_manage-users}','manage-users','c873670d-8167-4205-af33-8519fdff5955','28d5185c-e40e-4d11-a93d-d54349888289',NULL),('ff884dea-c46e-4419-b751-b0592f7103af','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,'Pilot role for FlightHours application','pilot','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',NULL,NULL);
/*!40000 ALTER TABLE `KEYCLOAK_ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MIGRATION_MODEL`
--

DROP TABLE IF EXISTS `MIGRATION_MODEL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MIGRATION_MODEL` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VERSION` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UPDATE_TIME` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_MIGRATION_UPDATE_TIME` (`UPDATE_TIME`),
  UNIQUE KEY `UK_MIGRATION_VERSION` (`VERSION`),
  KEY `IDX_UPDATE_TIME` (`UPDATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MIGRATION_MODEL`
--

LOCK TABLES `MIGRATION_MODEL` WRITE;
/*!40000 ALTER TABLE `MIGRATION_MODEL` DISABLE KEYS */;
INSERT INTO `MIGRATION_MODEL` (`ID`, `VERSION`, `UPDATE_TIME`) VALUES ('f164o','26.4.7',1766752915),('wk6wr','26.4.0',1765919072);
/*!40000 ALTER TABLE `MIGRATION_MODEL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OFFLINE_CLIENT_SESSION`
--

DROP TABLE IF EXISTS `OFFLINE_CLIENT_SESSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OFFLINE_CLIENT_SESSION` (
  `USER_SESSION_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `OFFLINE_FLAG` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TIMESTAMP` int DEFAULT NULL,
  `DATA` longtext COLLATE utf8mb4_unicode_ci,
  `CLIENT_STORAGE_PROVIDER` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `EXTERNAL_CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `VERSION` int DEFAULT '0',
  PRIMARY KEY (`USER_SESSION_ID`,`CLIENT_ID`,`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`,`OFFLINE_FLAG`),
  KEY `IDX_OFFLINE_CSS_BY_CLIENT` (`CLIENT_ID`,`OFFLINE_FLAG`),
  KEY `IDX_OFFLINE_CSS_BY_CLIENT_STORAGE_PROVIDER` (`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`,`OFFLINE_FLAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OFFLINE_CLIENT_SESSION`
--

LOCK TABLES `OFFLINE_CLIENT_SESSION` WRITE;
/*!40000 ALTER TABLE `OFFLINE_CLIENT_SESSION` DISABLE KEYS */;
INSERT INTO `OFFLINE_CLIENT_SESSION` (`USER_SESSION_ID`, `CLIENT_ID`, `OFFLINE_FLAG`, `TIMESTAMP`, `DATA`, `CLIENT_STORAGE_PROVIDER`, `EXTERNAL_CLIENT_ID`, `VERSION`) VALUES ('02e83c71-d6a5-c728-0e49-3b4fbbae18a7','8ecfbb96-b50c-41c4-8161-8d1b4aad085b','0',1772718269,'{\"authMethod\":\"openid-connect\",\"notes\":{\"clientId\":\"8ecfbb96-b50c-41c4-8161-8d1b4aad085b\",\"scope\":\"openid\",\"userSessionStartedAt\":\"1772718269\",\"iss\":\"http://localhost:8080/realms/flighthours\",\"startedAt\":\"1772718269\",\"level-of-authentication\":\"-1\"}}','local','local',0),('2d6f9c21-d872-8b8b-e50a-7f02670bbe7d','4fdac1f0-5e24-47cb-91a8-1be2b594eec3','0',1772718385,'{\"authMethod\":\"openid-connect\",\"notes\":{\"clientId\":\"4fdac1f0-5e24-47cb-91a8-1be2b594eec3\",\"userSessionStartedAt\":\"1772718385\",\"iss\":\"http://localhost:8080/realms/flighthours\",\"startedAt\":\"1772718385\",\"level-of-authentication\":\"-1\"}}','local','local',0),('37d9aa04-d907-aabc-795e-499d9af23791','4a9e15c1-378e-4a7d-a299-5a5a0823034d','0',1772740090,'{\"authMethod\":\"openid-connect\",\"redirectUri\":\"http://localhost:8080/admin/master/console/#/flighthours/users\",\"notes\":{\"clientId\":\"4a9e15c1-378e-4a7d-a299-5a5a0823034d\",\"iss\":\"http://localhost:8080/realms/master\",\"startedAt\":\"1772739900\",\"response_type\":\"code\",\"level-of-authentication\":\"-1\",\"code_challenge_method\":\"S256\",\"nonce\":\"7e87025e-70c8-49ed-89fc-848f8f86c68e\",\"response_mode\":\"query\",\"scope\":\"openid\",\"userSessionStartedAt\":\"1772739900\",\"redirect_uri\":\"http://localhost:8080/admin/master/console/#/flighthours/users\",\"state\":\"c851b135-3dd3-45eb-bc84-817777f4072e\",\"code_challenge\":\"GZbW0a6Wk1dwyH5Cz5U6kJAazOzrxnNVetEbawbqtCo\",\"SSO_AUTH\":\"true\"}}','local','local',1),('5754a9b0-a0ac-7a36-f2e7-1cb9ded2fb0f','4fdac1f0-5e24-47cb-91a8-1be2b594eec3','0',1772718101,'{\"authMethod\":\"openid-connect\",\"notes\":{\"clientId\":\"4fdac1f0-5e24-47cb-91a8-1be2b594eec3\",\"userSessionStartedAt\":\"1772718101\",\"iss\":\"http://localhost:8080/realms/flighthours\",\"startedAt\":\"1772718101\",\"level-of-authentication\":\"-1\"}}','local','local',0),('a1728b79-a21c-3177-8bd2-f1794e29daa3','8ecfbb96-b50c-41c4-8161-8d1b4aad085b','0',1772718403,'{\"authMethod\":\"openid-connect\",\"notes\":{\"clientId\":\"8ecfbb96-b50c-41c4-8161-8d1b4aad085b\",\"scope\":\"openid\",\"userSessionStartedAt\":\"1772718403\",\"iss\":\"http://localhost:8080/realms/flighthours\",\"startedAt\":\"1772718403\",\"level-of-authentication\":\"-1\"}}','local','local',0),('b97feb43-f3a7-4bbb-398c-5695f814224f','8ecfbb96-b50c-41c4-8161-8d1b4aad085b','0',1772718293,'{\"authMethod\":\"openid-connect\",\"notes\":{\"clientId\":\"8ecfbb96-b50c-41c4-8161-8d1b4aad085b\",\"scope\":\"openid\",\"userSessionStartedAt\":\"1772718293\",\"iss\":\"http://localhost:8080/realms/flighthours\",\"startedAt\":\"1772718293\",\"level-of-authentication\":\"-1\"}}','local','local',0);
/*!40000 ALTER TABLE `OFFLINE_CLIENT_SESSION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OFFLINE_USER_SESSION`
--

DROP TABLE IF EXISTS `OFFLINE_USER_SESSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OFFLINE_USER_SESSION` (
  `USER_SESSION_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `USER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CREATED_ON` int NOT NULL,
  `OFFLINE_FLAG` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DATA` longtext COLLATE utf8mb4_unicode_ci,
  `LAST_SESSION_REFRESH` int NOT NULL DEFAULT '0',
  `BROKER_SESSION_ID` text COLLATE utf8mb4_unicode_ci,
  `VERSION` int DEFAULT '0',
  PRIMARY KEY (`USER_SESSION_ID`,`OFFLINE_FLAG`),
  KEY `IDX_OFFLINE_USS_BY_USER` (`USER_ID`,`REALM_ID`,`OFFLINE_FLAG`),
  KEY `IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH` (`REALM_ID`,`OFFLINE_FLAG`,`LAST_SESSION_REFRESH`),
  KEY `IDX_OFFLINE_USS_BY_BROKER_SESSION_ID` (`BROKER_SESSION_ID`(255),`REALM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OFFLINE_USER_SESSION`
--

LOCK TABLES `OFFLINE_USER_SESSION` WRITE;
/*!40000 ALTER TABLE `OFFLINE_USER_SESSION` DISABLE KEYS */;
INSERT INTO `OFFLINE_USER_SESSION` (`USER_SESSION_ID`, `USER_ID`, `REALM_ID`, `CREATED_ON`, `OFFLINE_FLAG`, `DATA`, `LAST_SESSION_REFRESH`, `BROKER_SESSION_ID`, `VERSION`) VALUES ('02e83c71-d6a5-c728-0e49-3b4fbbae18a7','616357a0-a6e4-4514-94c7-f734eda2a685','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1772718269,'0','{\"ipAddress\":\"172.217.162.155\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxNzIuMjE3LjE2Mi4xNTUiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJnby1yZXN0eS8yLjcuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=\",\"authenticators-completed\":\"{\\\"ac3a24ac-8a77-4f03-bf72-c8c20aec3fc4\\\":1772718269,\\\"b772d8aa-5905-49e0-9e3d-69e2d6752c33\\\":1772718269}\"},\"state\":\"LOGGED_IN\"}',1772718269,NULL,0),('2d6f9c21-d872-8b8b-e50a-7f02670bbe7d','fb2b2b63-df46-4b1a-8244-ffa990c06ccc','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1772718385,'0','{\"ipAddress\":\"172.217.162.155\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxNzIuMjE3LjE2Mi4xNTUiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJnby1yZXN0eS8yLjcuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=\",\"authenticators-completed\":\"{\\\"ac3a24ac-8a77-4f03-bf72-c8c20aec3fc4\\\":1772718385,\\\"b772d8aa-5905-49e0-9e3d-69e2d6752c33\\\":1772718385}\"},\"state\":\"LOGGED_IN\"}',1772718385,NULL,0),('37d9aa04-d907-aabc-795e-499d9af23791','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee','c873670d-8167-4205-af33-8519fdff5955',1772739900,'0','{\"ipAddress\":\"172.23.0.1\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxNzIuMjMuMC4xIiwib3MiOiJNYWMgT1MgWCIsIm9zVmVyc2lvbiI6IjEwLjE1LjciLCJicm93c2VyIjoiQ2hyb21lLzE0NS4wLjAiLCJkZXZpY2UiOiJNYWMiLCJsYXN0QWNjZXNzIjowLCJtb2JpbGUiOmZhbHNlfQ==\",\"AUTH_TIME\":\"1772739900\",\"authenticators-completed\":\"{\\\"65c26f67-8e75-4b48-88c5-fea390a59db1\\\":1772739900,\\\"4940e656-000a-4079-9211-ddef34976ef8\\\":1772740090}\"},\"state\":\"LOGGED_IN\"}',1772740090,NULL,1),('5754a9b0-a0ac-7a36-f2e7-1cb9ded2fb0f','fb2b2b63-df46-4b1a-8244-ffa990c06ccc','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1772718101,'0','{\"ipAddress\":\"172.217.162.155\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxNzIuMjE3LjE2Mi4xNTUiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJnby1yZXN0eS8yLjcuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=\",\"authenticators-completed\":\"{\\\"ac3a24ac-8a77-4f03-bf72-c8c20aec3fc4\\\":1772718101,\\\"b772d8aa-5905-49e0-9e3d-69e2d6752c33\\\":1772718101}\"},\"state\":\"LOGGED_IN\"}',1772718101,NULL,0),('a1728b79-a21c-3177-8bd2-f1794e29daa3','616357a0-a6e4-4514-94c7-f734eda2a685','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1772718403,'0','{\"ipAddress\":\"172.217.162.155\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxNzIuMjE3LjE2Mi4xNTUiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJnby1yZXN0eS8yLjcuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=\",\"authenticators-completed\":\"{\\\"ac3a24ac-8a77-4f03-bf72-c8c20aec3fc4\\\":1772718403,\\\"b772d8aa-5905-49e0-9e3d-69e2d6752c33\\\":1772718403}\"},\"state\":\"LOGGED_IN\"}',1772718403,NULL,0),('b97feb43-f3a7-4bbb-398c-5695f814224f','fb2b2b63-df46-4b1a-8244-ffa990c06ccc','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1772718293,'0','{\"ipAddress\":\"172.217.162.155\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxNzIuMjE3LjE2Mi4xNTUiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJnby1yZXN0eS8yLjcuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=\",\"authenticators-completed\":\"{\\\"ac3a24ac-8a77-4f03-bf72-c8c20aec3fc4\\\":1772718293,\\\"b772d8aa-5905-49e0-9e3d-69e2d6752c33\\\":1772718293}\"},\"state\":\"LOGGED_IN\"}',1772718293,NULL,0);
/*!40000 ALTER TABLE `OFFLINE_USER_SESSION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORG`
--

DROP TABLE IF EXISTS `ORG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORG` (
  `ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ENABLED` tinyint NOT NULL,
  `REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `GROUP_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` text COLLATE utf8mb4_unicode_ci,
  `ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REDIRECT_URL` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_ORG_NAME` (`REALM_ID`,`NAME`),
  UNIQUE KEY `UK_ORG_GROUP` (`GROUP_ID`),
  UNIQUE KEY `UK_ORG_ALIAS` (`REALM_ID`,`ALIAS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORG`
--

LOCK TABLES `ORG` WRITE;
/*!40000 ALTER TABLE `ORG` DISABLE KEYS */;
/*!40000 ALTER TABLE `ORG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORG_DOMAIN`
--

DROP TABLE IF EXISTS `ORG_DOMAIN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORG_DOMAIN` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VERIFIED` tinyint NOT NULL,
  `ORG_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`,`NAME`),
  KEY `IDX_ORG_DOMAIN_ORG_ID` (`ORG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORG_DOMAIN`
--

LOCK TABLES `ORG_DOMAIN` WRITE;
/*!40000 ALTER TABLE `ORG_DOMAIN` DISABLE KEYS */;
/*!40000 ALTER TABLE `ORG_DOMAIN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POLICY_CONFIG`
--

DROP TABLE IF EXISTS `POLICY_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POLICY_CONFIG` (
  `POLICY_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`POLICY_ID`,`NAME`),
  CONSTRAINT `FKDC34197CF864C4E43` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POLICY_CONFIG`
--

LOCK TABLES `POLICY_CONFIG` WRITE;
/*!40000 ALTER TABLE `POLICY_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `POLICY_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROTOCOL_MAPPER`
--

DROP TABLE IF EXISTS `PROTOCOL_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROTOCOL_MAPPER` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PROTOCOL` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PROTOCOL_MAPPER_NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CLIENT_SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_PROTOCOL_MAPPER_CLIENT` (`CLIENT_ID`),
  KEY `IDX_CLSCOPE_PROTMAP` (`CLIENT_SCOPE_ID`),
  CONSTRAINT `FK_CLI_SCOPE_MAPPER` FOREIGN KEY (`CLIENT_SCOPE_ID`) REFERENCES `CLIENT_SCOPE` (`ID`),
  CONSTRAINT `FK_PCM_REALM` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROTOCOL_MAPPER`
--

LOCK TABLES `PROTOCOL_MAPPER` WRITE;
/*!40000 ALTER TABLE `PROTOCOL_MAPPER` DISABLE KEYS */;
INSERT INTO `PROTOCOL_MAPPER` (`ID`, `NAME`, `PROTOCOL`, `PROTOCOL_MAPPER_NAME`, `CLIENT_ID`, `CLIENT_SCOPE_ID`) VALUES ('00917b24-b847-4aa3-9af4-7437415ecfb4','realm roles','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8'),('012a76da-86bd-4247-9a18-df35d855c76b','username','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('03d69154-3bad-4f7c-a4de-698a3c100164','email','openid-connect','oidc-usermodel-attribute-mapper',NULL,'74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','email','openid-connect','oidc-usermodel-attribute-mapper',NULL,'b108748b-23a0-430a-9921-c1f1fcbe3548'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','organization','openid-connect','oidc-organization-membership-mapper',NULL,'21f57746-bd06-4754-98dc-5d5644197a1c'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','middle name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','email verified','openid-connect','oidc-usermodel-property-mapper',NULL,'74e0ad0d-cfca-45b8-ac2e-c1a3a7bdba50'),('213163a6-ef75-4e4c-9e26-79f9d9cf9e61','role list','saml','saml-role-list-mapper',NULL,'0dce6a7b-00e3-46f7-91ce-0ebab2c4cb40'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','auth_time','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'eab91a8c-7bf3-4217-8a44-28fa150ec6ab'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','groups','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'cf90ce90-377b-426c-bd98-b92acd4e85f3'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','middle name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('2ddbf97c-eb16-45de-832f-0748d0c48995','locale','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('32085872-3897-4e58-adac-33dc83589a2b','Client Host','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'ebd52604-b8ba-453e-9421-875b746626dc'),('384dddeb-282c-4d2b-a91b-cb16a237de26','phone number','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a743a1b7-0c2a-4574-9cea-705a924a771b'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','nickname','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','username','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('4acd117a-dabc-4337-b3ed-8e1ed56a7299','sub','openid-connect','oidc-sub-mapper',NULL,'e541d53a-0702-4352-a8db-1f21c3f32577'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','address','openid-connect','oidc-address-mapper',NULL,'1525a54b-4819-4ec1-b7a5-a4fd59b46a87'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','realm roles','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'229b3874-96b9-4b24-86be-1c77178fecbf'),('59123e88-e994-4425-89ad-35e23aa3423e','Client IP Address','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'1bbf5f24-4928-462e-b7e8-3aaef5c451d0'),('59479af2-5b9b-47c5-bfa0-23678874c089','full name','openid-connect','oidc-full-name-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','phone number','openid-connect','oidc-usermodel-attribute-mapper',NULL,'d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab'),('716df944-4304-47ab-b2b4-5b73b89cbe95','picture','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','upn','openid-connect','oidc-usermodel-attribute-mapper',NULL,'b0db2e23-0e7d-4738-bbd2-c3df4d2325f0'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','phone number verified','openid-connect','oidc-usermodel-attribute-mapper',NULL,'d4e7e6c0-50a6-4ad0-aae5-9a0493f2baab'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','gender','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('87a016cb-9345-4461-89ae-2e1e785b38f4','Client IP Address','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'ebd52604-b8ba-453e-9421-875b746626dc'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','website','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','upn','openid-connect','oidc-usermodel-attribute-mapper',NULL,'cf90ce90-377b-426c-bd98-b92acd4e85f3'),('91a031da-24f7-4515-84d0-df57c14ec9e2','client roles','openid-connect','oidc-usermodel-client-role-mapper',NULL,'229b3874-96b9-4b24-86be-1c77178fecbf'),('91bf3051-a526-46c6-a8a4-0457e61d074a','birthdate','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('91f7aa0f-a478-42d3-aa6c-1ac82acceafc','audience resolve','openid-connect','oidc-audience-resolve-mapper',NULL,'229b3874-96b9-4b24-86be-1c77178fecbf'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','Client ID','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'1bbf5f24-4928-462e-b7e8-3aaef5c451d0'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','updated at','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('976fe179-c762-4772-b08c-1930d268528e','phone number verified','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a743a1b7-0c2a-4574-9cea-705a924a771b'),('9b2e4bcc-cbc8-4568-a26f-598c28b5405d','audience resolve','openid-connect','oidc-audience-resolve-mapper',NULL,'5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8'),('a3bd7588-b507-4347-9f97-0cf8655d4540','given name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','locale','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','updated at','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('a676531b-ee77-4465-987d-75c3225754d2','website','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('a98ca506-5870-43e3-afe3-e19c8c4018b9','acr loa level','openid-connect','oidc-acr-mapper',NULL,'18acd87e-defa-442c-9f22-17de31d3e6c6'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','auth_time','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'e541d53a-0702-4352-a8db-1f21c3f32577'),('ae3f00aa-3826-47a1-93de-254bed1fa697','given name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('afe045dc-3e74-4e20-8501-fca727edad9d','email verified','openid-connect','oidc-usermodel-property-mapper',NULL,'b108748b-23a0-430a-9921-c1f1fcbe3548'),('b353bc60-e553-48a3-910e-2ab80cc10043','Client ID','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'ebd52604-b8ba-453e-9421-875b746626dc'),('b4e00095-9cf4-441a-abf7-2b9c65bedfd0','role list','saml','saml-role-list-mapper',NULL,'4a4f1740-3ff8-4d0a-b393-a080cfe5eab6'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','zoneinfo','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('b75d4d18-0093-44b9-8f78-b89de666731b','picture','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','locale','openid-connect','oidc-usermodel-attribute-mapper','4a9e15c1-378e-4a7d-a299-5a5a0823034d',NULL),('bb0c31ce-6a3d-471d-86f1-930c64c77012','sub','openid-connect','oidc-sub-mapper',NULL,'eab91a8c-7bf3-4217-8a44-28fa150ec6ab'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','client roles','openid-connect','oidc-usermodel-client-role-mapper',NULL,'5ce05bf9-b5b7-4005-9dc2-4e93ece6ace8'),('c193b706-f2ea-404c-9a80-fc94df9bd59c','full name','openid-connect','oidc-full-name-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','address','openid-connect','oidc-address-mapper',NULL,'28384917-02ed-4cff-b623-7b07312e6957'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','locale','openid-connect','oidc-usermodel-attribute-mapper','6632f16a-9ca9-4fc9-a2af-9f2cefe78778',NULL),('ca451ea1-c9a6-44ac-a1a1-c8d657a0b1b1','organization','saml','saml-organization-membership-mapper',NULL,'492a67dc-ab1a-411b-8aff-5a1e8f4c9153'),('cd824bda-d383-4c4b-9c36-307edd7d7292','audience resolve','openid-connect','oidc-audience-resolve-mapper','9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae',NULL),('d18126ee-de42-45ec-ab23-5cfc63564ee3','family name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','organization','openid-connect','oidc-organization-membership-mapper',NULL,'f03c0dde-12e1-4771-a74e-6f6515c2ecf3'),('dacf7a6e-6505-449a-8df9-0229fd4cdd4a','acr loa level','openid-connect','oidc-acr-mapper',NULL,'e6a2a5c8-f86a-4177-9e8e-b43e0dfef05e'),('dce9e651-50ec-4fe4-b01f-5e096746e205','nickname','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('df1d77c1-4167-414a-ac56-4d9b145c3443','profile','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','gender','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('e6258ad3-0e97-48b2-8065-9b3165277569','family name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('e9c3848e-6d4a-4518-8ed5-f5347eba7a52','organization','saml','saml-organization-membership-mapper',NULL,'2a71c4c4-6670-4109-a418-7cad37eae11f'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','groups','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'b0db2e23-0e7d-4738-bbd2-c3df4d2325f0'),('ebc36e92-f273-4b51-8e3f-63a47047eaad','allowed web origins','openid-connect','oidc-allowed-origins-mapper',NULL,'ef0b0964-0624-4733-8b8e-688a1db399db'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','zoneinfo','openid-connect','oidc-usermodel-attribute-mapper',NULL,'a9c6cbeb-1e10-475c-a89e-3ba7c669468f'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','profile','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('f630e460-894b-42f5-8ac7-1a7b6daef031','allowed web origins','openid-connect','oidc-allowed-origins-mapper',NULL,'e9aa4630-2911-4e04-bc19-b3bcf1a6083a'),('f836364b-206c-4055-a008-5657de4bc08e','birthdate','openid-connect','oidc-usermodel-attribute-mapper',NULL,'6b58bdf3-ba9e-4138-98cc-2adfe96a84b1'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','Client Host','openid-connect','oidc-usersessionmodel-note-mapper',NULL,'1bbf5f24-4928-462e-b7e8-3aaef5c451d0'),('ffe82514-0da3-40b5-b267-45a7c91b2062','audience resolve','openid-connect','oidc-audience-resolve-mapper','f2fa0263-8f33-4398-9630-fcf973ed4dc5',NULL);
/*!40000 ALTER TABLE `PROTOCOL_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROTOCOL_MAPPER_CONFIG`
--

DROP TABLE IF EXISTS `PROTOCOL_MAPPER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROTOCOL_MAPPER_CONFIG` (
  `PROTOCOL_MAPPER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`PROTOCOL_MAPPER_ID`,`NAME`),
  CONSTRAINT `FK_PMCONFIG` FOREIGN KEY (`PROTOCOL_MAPPER_ID`) REFERENCES `PROTOCOL_MAPPER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROTOCOL_MAPPER_CONFIG`
--

LOCK TABLES `PROTOCOL_MAPPER_CONFIG` WRITE;
/*!40000 ALTER TABLE `PROTOCOL_MAPPER_CONFIG` DISABLE KEYS */;
INSERT INTO `PROTOCOL_MAPPER_CONFIG` (`PROTOCOL_MAPPER_ID`, `VALUE`, `NAME`) VALUES ('00917b24-b847-4aa3-9af4-7437415ecfb4','true','access.token.claim'),('00917b24-b847-4aa3-9af4-7437415ecfb4','realm_access.roles','claim.name'),('00917b24-b847-4aa3-9af4-7437415ecfb4','true','introspection.token.claim'),('00917b24-b847-4aa3-9af4-7437415ecfb4','String','jsonType.label'),('00917b24-b847-4aa3-9af4-7437415ecfb4','true','multivalued'),('00917b24-b847-4aa3-9af4-7437415ecfb4','foo','user.attribute'),('012a76da-86bd-4247-9a18-df35d855c76b','true','access.token.claim'),('012a76da-86bd-4247-9a18-df35d855c76b','preferred_username','claim.name'),('012a76da-86bd-4247-9a18-df35d855c76b','true','id.token.claim'),('012a76da-86bd-4247-9a18-df35d855c76b','true','introspection.token.claim'),('012a76da-86bd-4247-9a18-df35d855c76b','String','jsonType.label'),('012a76da-86bd-4247-9a18-df35d855c76b','username','user.attribute'),('012a76da-86bd-4247-9a18-df35d855c76b','true','userinfo.token.claim'),('03d69154-3bad-4f7c-a4de-698a3c100164','true','access.token.claim'),('03d69154-3bad-4f7c-a4de-698a3c100164','email','claim.name'),('03d69154-3bad-4f7c-a4de-698a3c100164','true','id.token.claim'),('03d69154-3bad-4f7c-a4de-698a3c100164','true','introspection.token.claim'),('03d69154-3bad-4f7c-a4de-698a3c100164','String','jsonType.label'),('03d69154-3bad-4f7c-a4de-698a3c100164','email','user.attribute'),('03d69154-3bad-4f7c-a4de-698a3c100164','true','userinfo.token.claim'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','true','access.token.claim'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','email','claim.name'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','true','id.token.claim'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','true','introspection.token.claim'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','String','jsonType.label'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','email','user.attribute'),('0a75db51-751c-4934-aa54-8952d8f2bd1c','true','userinfo.token.claim'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','true','access.token.claim'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','organization','claim.name'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','true','id.token.claim'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','true','introspection.token.claim'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','String','jsonType.label'),('0d07247d-565d-4c0b-97b6-e46de5fe0c46','true','multivalued'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','true','access.token.claim'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','middle_name','claim.name'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','true','id.token.claim'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','true','introspection.token.claim'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','String','jsonType.label'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','middleName','user.attribute'),('145586f7-8a6a-42f5-9f42-0f2a1582e347','true','userinfo.token.claim'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','true','access.token.claim'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','email_verified','claim.name'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','true','id.token.claim'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','true','introspection.token.claim'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','boolean','jsonType.label'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','emailVerified','user.attribute'),('1bdb402c-c813-4670-9b9d-2b65aed7321e','true','userinfo.token.claim'),('213163a6-ef75-4e4c-9e26-79f9d9cf9e61','Role','attribute.name'),('213163a6-ef75-4e4c-9e26-79f9d9cf9e61','Basic','attribute.nameformat'),('213163a6-ef75-4e4c-9e26-79f9d9cf9e61','false','single'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','true','access.token.claim'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','auth_time','claim.name'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','true','id.token.claim'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','true','introspection.token.claim'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','long','jsonType.label'),('257a9ce7-98c9-4f59-b3a3-47c56b7a2d88','AUTH_TIME','user.session.note'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','true','access.token.claim'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','groups','claim.name'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','true','id.token.claim'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','true','introspection.token.claim'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','String','jsonType.label'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','true','multivalued'),('27a1ac91-34e7-41fb-aafe-b4a28fc96af3','foo','user.attribute'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','true','access.token.claim'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','middle_name','claim.name'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','true','id.token.claim'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','true','introspection.token.claim'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','String','jsonType.label'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','middleName','user.attribute'),('29fdde59-58ef-4e3f-9ec7-9242d18d5b0b','true','userinfo.token.claim'),('2ddbf97c-eb16-45de-832f-0748d0c48995','true','access.token.claim'),('2ddbf97c-eb16-45de-832f-0748d0c48995','locale','claim.name'),('2ddbf97c-eb16-45de-832f-0748d0c48995','true','id.token.claim'),('2ddbf97c-eb16-45de-832f-0748d0c48995','true','introspection.token.claim'),('2ddbf97c-eb16-45de-832f-0748d0c48995','String','jsonType.label'),('2ddbf97c-eb16-45de-832f-0748d0c48995','locale','user.attribute'),('2ddbf97c-eb16-45de-832f-0748d0c48995','true','userinfo.token.claim'),('32085872-3897-4e58-adac-33dc83589a2b','true','access.token.claim'),('32085872-3897-4e58-adac-33dc83589a2b','clientHost','claim.name'),('32085872-3897-4e58-adac-33dc83589a2b','true','id.token.claim'),('32085872-3897-4e58-adac-33dc83589a2b','true','introspection.token.claim'),('32085872-3897-4e58-adac-33dc83589a2b','String','jsonType.label'),('32085872-3897-4e58-adac-33dc83589a2b','clientHost','user.session.note'),('384dddeb-282c-4d2b-a91b-cb16a237de26','true','access.token.claim'),('384dddeb-282c-4d2b-a91b-cb16a237de26','phone_number','claim.name'),('384dddeb-282c-4d2b-a91b-cb16a237de26','true','id.token.claim'),('384dddeb-282c-4d2b-a91b-cb16a237de26','true','introspection.token.claim'),('384dddeb-282c-4d2b-a91b-cb16a237de26','String','jsonType.label'),('384dddeb-282c-4d2b-a91b-cb16a237de26','phoneNumber','user.attribute'),('384dddeb-282c-4d2b-a91b-cb16a237de26','true','userinfo.token.claim'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','true','access.token.claim'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','nickname','claim.name'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','true','id.token.claim'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','true','introspection.token.claim'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','String','jsonType.label'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','nickname','user.attribute'),('3aafb20a-237e-42d6-a27d-974d1581dcb3','true','userinfo.token.claim'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','true','access.token.claim'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','preferred_username','claim.name'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','true','id.token.claim'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','true','introspection.token.claim'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','String','jsonType.label'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','username','user.attribute'),('48505fd9-0ad9-49c4-ada7-27bbfd056e5a','true','userinfo.token.claim'),('4acd117a-dabc-4337-b3ed-8e1ed56a7299','true','access.token.claim'),('4acd117a-dabc-4337-b3ed-8e1ed56a7299','true','introspection.token.claim'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','true','access.token.claim'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','true','id.token.claim'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','true','introspection.token.claim'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','country','user.attribute.country'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','formatted','user.attribute.formatted'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','locality','user.attribute.locality'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','postal_code','user.attribute.postal_code'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','region','user.attribute.region'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','street','user.attribute.street'),('4d8c89eb-a546-48a8-8324-7c1b8f9c53ee','true','userinfo.token.claim'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','true','access.token.claim'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','realm_access.roles','claim.name'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','true','introspection.token.claim'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','String','jsonType.label'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','true','multivalued'),('585dfb90-bd9a-41d8-b0c0-20d8d9798fb6','foo','user.attribute'),('59123e88-e994-4425-89ad-35e23aa3423e','true','access.token.claim'),('59123e88-e994-4425-89ad-35e23aa3423e','clientAddress','claim.name'),('59123e88-e994-4425-89ad-35e23aa3423e','true','id.token.claim'),('59123e88-e994-4425-89ad-35e23aa3423e','true','introspection.token.claim'),('59123e88-e994-4425-89ad-35e23aa3423e','String','jsonType.label'),('59123e88-e994-4425-89ad-35e23aa3423e','clientAddress','user.session.note'),('59479af2-5b9b-47c5-bfa0-23678874c089','true','access.token.claim'),('59479af2-5b9b-47c5-bfa0-23678874c089','true','id.token.claim'),('59479af2-5b9b-47c5-bfa0-23678874c089','true','introspection.token.claim'),('59479af2-5b9b-47c5-bfa0-23678874c089','true','userinfo.token.claim'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','true','access.token.claim'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','phone_number','claim.name'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','true','id.token.claim'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','true','introspection.token.claim'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','String','jsonType.label'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','phoneNumber','user.attribute'),('675ec97a-139c-47e1-b97d-cdf820b3c2f8','true','userinfo.token.claim'),('716df944-4304-47ab-b2b4-5b73b89cbe95','true','access.token.claim'),('716df944-4304-47ab-b2b4-5b73b89cbe95','picture','claim.name'),('716df944-4304-47ab-b2b4-5b73b89cbe95','true','id.token.claim'),('716df944-4304-47ab-b2b4-5b73b89cbe95','true','introspection.token.claim'),('716df944-4304-47ab-b2b4-5b73b89cbe95','String','jsonType.label'),('716df944-4304-47ab-b2b4-5b73b89cbe95','picture','user.attribute'),('716df944-4304-47ab-b2b4-5b73b89cbe95','true','userinfo.token.claim'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','true','access.token.claim'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','upn','claim.name'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','true','id.token.claim'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','true','introspection.token.claim'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','String','jsonType.label'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','username','user.attribute'),('77a3b221-a770-47d4-a727-72f0ff9ea5a7','true','userinfo.token.claim'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','true','access.token.claim'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','phone_number_verified','claim.name'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','true','id.token.claim'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','true','introspection.token.claim'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','boolean','jsonType.label'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','phoneNumberVerified','user.attribute'),('7b12669e-a5e6-4aeb-9a5b-a81d0ce3e51e','true','userinfo.token.claim'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','true','access.token.claim'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','gender','claim.name'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','true','id.token.claim'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','true','introspection.token.claim'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','String','jsonType.label'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','gender','user.attribute'),('806a4f4a-bd24-4af8-a3e4-2ce5a9bf7296','true','userinfo.token.claim'),('87a016cb-9345-4461-89ae-2e1e785b38f4','true','access.token.claim'),('87a016cb-9345-4461-89ae-2e1e785b38f4','clientAddress','claim.name'),('87a016cb-9345-4461-89ae-2e1e785b38f4','true','id.token.claim'),('87a016cb-9345-4461-89ae-2e1e785b38f4','true','introspection.token.claim'),('87a016cb-9345-4461-89ae-2e1e785b38f4','String','jsonType.label'),('87a016cb-9345-4461-89ae-2e1e785b38f4','clientAddress','user.session.note'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','true','access.token.claim'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','website','claim.name'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','true','id.token.claim'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','true','introspection.token.claim'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','String','jsonType.label'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','website','user.attribute'),('8c06851f-f252-49b8-9ab2-bd948959e6e3','true','userinfo.token.claim'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','true','access.token.claim'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','upn','claim.name'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','true','id.token.claim'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','true','introspection.token.claim'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','String','jsonType.label'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','username','user.attribute'),('8ee022f4-fc8b-49c5-b56e-5cd351604331','true','userinfo.token.claim'),('91a031da-24f7-4515-84d0-df57c14ec9e2','true','access.token.claim'),('91a031da-24f7-4515-84d0-df57c14ec9e2','resource_access.${client_id}.roles','claim.name'),('91a031da-24f7-4515-84d0-df57c14ec9e2','true','introspection.token.claim'),('91a031da-24f7-4515-84d0-df57c14ec9e2','String','jsonType.label'),('91a031da-24f7-4515-84d0-df57c14ec9e2','true','multivalued'),('91a031da-24f7-4515-84d0-df57c14ec9e2','foo','user.attribute'),('91bf3051-a526-46c6-a8a4-0457e61d074a','true','access.token.claim'),('91bf3051-a526-46c6-a8a4-0457e61d074a','birthdate','claim.name'),('91bf3051-a526-46c6-a8a4-0457e61d074a','true','id.token.claim'),('91bf3051-a526-46c6-a8a4-0457e61d074a','true','introspection.token.claim'),('91bf3051-a526-46c6-a8a4-0457e61d074a','String','jsonType.label'),('91bf3051-a526-46c6-a8a4-0457e61d074a','birthdate','user.attribute'),('91bf3051-a526-46c6-a8a4-0457e61d074a','true','userinfo.token.claim'),('91f7aa0f-a478-42d3-aa6c-1ac82acceafc','true','access.token.claim'),('91f7aa0f-a478-42d3-aa6c-1ac82acceafc','true','introspection.token.claim'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','true','access.token.claim'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','client_id','claim.name'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','true','id.token.claim'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','true','introspection.token.claim'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','String','jsonType.label'),('9446f9cc-a9f3-4147-b5fe-ef6247ae1e49','client_id','user.session.note'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','true','access.token.claim'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','updated_at','claim.name'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','true','id.token.claim'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','true','introspection.token.claim'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','long','jsonType.label'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','updatedAt','user.attribute'),('94d952c4-c06c-43db-9406-7ae9c0a515e6','true','userinfo.token.claim'),('976fe179-c762-4772-b08c-1930d268528e','true','access.token.claim'),('976fe179-c762-4772-b08c-1930d268528e','phone_number_verified','claim.name'),('976fe179-c762-4772-b08c-1930d268528e','true','id.token.claim'),('976fe179-c762-4772-b08c-1930d268528e','true','introspection.token.claim'),('976fe179-c762-4772-b08c-1930d268528e','boolean','jsonType.label'),('976fe179-c762-4772-b08c-1930d268528e','phoneNumberVerified','user.attribute'),('976fe179-c762-4772-b08c-1930d268528e','true','userinfo.token.claim'),('9b2e4bcc-cbc8-4568-a26f-598c28b5405d','true','access.token.claim'),('9b2e4bcc-cbc8-4568-a26f-598c28b5405d','true','introspection.token.claim'),('a3bd7588-b507-4347-9f97-0cf8655d4540','true','access.token.claim'),('a3bd7588-b507-4347-9f97-0cf8655d4540','given_name','claim.name'),('a3bd7588-b507-4347-9f97-0cf8655d4540','true','id.token.claim'),('a3bd7588-b507-4347-9f97-0cf8655d4540','true','introspection.token.claim'),('a3bd7588-b507-4347-9f97-0cf8655d4540','String','jsonType.label'),('a3bd7588-b507-4347-9f97-0cf8655d4540','firstName','user.attribute'),('a3bd7588-b507-4347-9f97-0cf8655d4540','true','userinfo.token.claim'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','true','access.token.claim'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','locale','claim.name'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','true','id.token.claim'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','true','introspection.token.claim'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','String','jsonType.label'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','locale','user.attribute'),('a587fa4b-f0fe-4e02-b6f4-5ea0a6f3d7e6','true','userinfo.token.claim'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','true','access.token.claim'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','updated_at','claim.name'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','true','id.token.claim'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','true','introspection.token.claim'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','long','jsonType.label'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','updatedAt','user.attribute'),('a650238a-d5d0-4be6-bdc4-4735f0529fc4','true','userinfo.token.claim'),('a676531b-ee77-4465-987d-75c3225754d2','true','access.token.claim'),('a676531b-ee77-4465-987d-75c3225754d2','website','claim.name'),('a676531b-ee77-4465-987d-75c3225754d2','true','id.token.claim'),('a676531b-ee77-4465-987d-75c3225754d2','true','introspection.token.claim'),('a676531b-ee77-4465-987d-75c3225754d2','String','jsonType.label'),('a676531b-ee77-4465-987d-75c3225754d2','website','user.attribute'),('a676531b-ee77-4465-987d-75c3225754d2','true','userinfo.token.claim'),('a98ca506-5870-43e3-afe3-e19c8c4018b9','true','access.token.claim'),('a98ca506-5870-43e3-afe3-e19c8c4018b9','true','id.token.claim'),('a98ca506-5870-43e3-afe3-e19c8c4018b9','true','introspection.token.claim'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','true','access.token.claim'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','auth_time','claim.name'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','true','id.token.claim'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','true','introspection.token.claim'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','long','jsonType.label'),('ac07cd3f-a3ee-4223-9607-170ee7e423fe','AUTH_TIME','user.session.note'),('ae3f00aa-3826-47a1-93de-254bed1fa697','true','access.token.claim'),('ae3f00aa-3826-47a1-93de-254bed1fa697','given_name','claim.name'),('ae3f00aa-3826-47a1-93de-254bed1fa697','true','id.token.claim'),('ae3f00aa-3826-47a1-93de-254bed1fa697','true','introspection.token.claim'),('ae3f00aa-3826-47a1-93de-254bed1fa697','String','jsonType.label'),('ae3f00aa-3826-47a1-93de-254bed1fa697','firstName','user.attribute'),('ae3f00aa-3826-47a1-93de-254bed1fa697','true','userinfo.token.claim'),('afe045dc-3e74-4e20-8501-fca727edad9d','true','access.token.claim'),('afe045dc-3e74-4e20-8501-fca727edad9d','email_verified','claim.name'),('afe045dc-3e74-4e20-8501-fca727edad9d','true','id.token.claim'),('afe045dc-3e74-4e20-8501-fca727edad9d','true','introspection.token.claim'),('afe045dc-3e74-4e20-8501-fca727edad9d','boolean','jsonType.label'),('afe045dc-3e74-4e20-8501-fca727edad9d','emailVerified','user.attribute'),('afe045dc-3e74-4e20-8501-fca727edad9d','true','userinfo.token.claim'),('b353bc60-e553-48a3-910e-2ab80cc10043','true','access.token.claim'),('b353bc60-e553-48a3-910e-2ab80cc10043','client_id','claim.name'),('b353bc60-e553-48a3-910e-2ab80cc10043','true','id.token.claim'),('b353bc60-e553-48a3-910e-2ab80cc10043','true','introspection.token.claim'),('b353bc60-e553-48a3-910e-2ab80cc10043','String','jsonType.label'),('b353bc60-e553-48a3-910e-2ab80cc10043','client_id','user.session.note'),('b4e00095-9cf4-441a-abf7-2b9c65bedfd0','Role','attribute.name'),('b4e00095-9cf4-441a-abf7-2b9c65bedfd0','Basic','attribute.nameformat'),('b4e00095-9cf4-441a-abf7-2b9c65bedfd0','false','single'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','true','access.token.claim'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','zoneinfo','claim.name'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','true','id.token.claim'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','true','introspection.token.claim'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','String','jsonType.label'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','zoneinfo','user.attribute'),('b73e6adf-fee3-4783-a7f2-205a87b88e5e','true','userinfo.token.claim'),('b75d4d18-0093-44b9-8f78-b89de666731b','true','access.token.claim'),('b75d4d18-0093-44b9-8f78-b89de666731b','picture','claim.name'),('b75d4d18-0093-44b9-8f78-b89de666731b','true','id.token.claim'),('b75d4d18-0093-44b9-8f78-b89de666731b','true','introspection.token.claim'),('b75d4d18-0093-44b9-8f78-b89de666731b','String','jsonType.label'),('b75d4d18-0093-44b9-8f78-b89de666731b','picture','user.attribute'),('b75d4d18-0093-44b9-8f78-b89de666731b','true','userinfo.token.claim'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','true','access.token.claim'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','locale','claim.name'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','true','id.token.claim'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','true','introspection.token.claim'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','String','jsonType.label'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','locale','user.attribute'),('ba94d9a9-228d-4309-80cc-bec941d42aa8','true','userinfo.token.claim'),('bb0c31ce-6a3d-471d-86f1-930c64c77012','true','access.token.claim'),('bb0c31ce-6a3d-471d-86f1-930c64c77012','true','introspection.token.claim'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','true','access.token.claim'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','resource_access.${client_id}.roles','claim.name'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','true','introspection.token.claim'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','String','jsonType.label'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','true','multivalued'),('bce7765d-4e4c-49ee-83ac-6ecc5510f6a8','foo','user.attribute'),('c193b706-f2ea-404c-9a80-fc94df9bd59c','true','access.token.claim'),('c193b706-f2ea-404c-9a80-fc94df9bd59c','true','id.token.claim'),('c193b706-f2ea-404c-9a80-fc94df9bd59c','true','introspection.token.claim'),('c193b706-f2ea-404c-9a80-fc94df9bd59c','true','userinfo.token.claim'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','true','access.token.claim'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','true','id.token.claim'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','true','introspection.token.claim'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','country','user.attribute.country'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','formatted','user.attribute.formatted'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','locality','user.attribute.locality'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','postal_code','user.attribute.postal_code'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','region','user.attribute.region'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','street','user.attribute.street'),('c5917e0c-e890-4542-b6b1-c42e3cfe76f9','true','userinfo.token.claim'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','true','access.token.claim'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','locale','claim.name'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','true','id.token.claim'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','true','introspection.token.claim'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','String','jsonType.label'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','locale','user.attribute'),('c6e66516-dc5f-46f4-8c44-4dd223a50b7b','true','userinfo.token.claim'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','true','access.token.claim'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','family_name','claim.name'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','true','id.token.claim'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','true','introspection.token.claim'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','String','jsonType.label'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','lastName','user.attribute'),('d18126ee-de42-45ec-ab23-5cfc63564ee3','true','userinfo.token.claim'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','true','access.token.claim'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','organization','claim.name'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','true','id.token.claim'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','true','introspection.token.claim'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','String','jsonType.label'),('d748c3da-9dfe-442a-96bf-64f8c2f1477f','true','multivalued'),('dacf7a6e-6505-449a-8df9-0229fd4cdd4a','true','access.token.claim'),('dacf7a6e-6505-449a-8df9-0229fd4cdd4a','true','id.token.claim'),('dacf7a6e-6505-449a-8df9-0229fd4cdd4a','true','introspection.token.claim'),('dce9e651-50ec-4fe4-b01f-5e096746e205','true','access.token.claim'),('dce9e651-50ec-4fe4-b01f-5e096746e205','nickname','claim.name'),('dce9e651-50ec-4fe4-b01f-5e096746e205','true','id.token.claim'),('dce9e651-50ec-4fe4-b01f-5e096746e205','true','introspection.token.claim'),('dce9e651-50ec-4fe4-b01f-5e096746e205','String','jsonType.label'),('dce9e651-50ec-4fe4-b01f-5e096746e205','nickname','user.attribute'),('dce9e651-50ec-4fe4-b01f-5e096746e205','true','userinfo.token.claim'),('df1d77c1-4167-414a-ac56-4d9b145c3443','true','access.token.claim'),('df1d77c1-4167-414a-ac56-4d9b145c3443','profile','claim.name'),('df1d77c1-4167-414a-ac56-4d9b145c3443','true','id.token.claim'),('df1d77c1-4167-414a-ac56-4d9b145c3443','true','introspection.token.claim'),('df1d77c1-4167-414a-ac56-4d9b145c3443','String','jsonType.label'),('df1d77c1-4167-414a-ac56-4d9b145c3443','profile','user.attribute'),('df1d77c1-4167-414a-ac56-4d9b145c3443','true','userinfo.token.claim'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','true','access.token.claim'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','gender','claim.name'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','true','id.token.claim'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','true','introspection.token.claim'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','String','jsonType.label'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','gender','user.attribute'),('e46d069a-e11d-4d7c-8773-70fa4a50d7c1','true','userinfo.token.claim'),('e6258ad3-0e97-48b2-8065-9b3165277569','true','access.token.claim'),('e6258ad3-0e97-48b2-8065-9b3165277569','family_name','claim.name'),('e6258ad3-0e97-48b2-8065-9b3165277569','true','id.token.claim'),('e6258ad3-0e97-48b2-8065-9b3165277569','true','introspection.token.claim'),('e6258ad3-0e97-48b2-8065-9b3165277569','String','jsonType.label'),('e6258ad3-0e97-48b2-8065-9b3165277569','lastName','user.attribute'),('e6258ad3-0e97-48b2-8065-9b3165277569','true','userinfo.token.claim'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','true','access.token.claim'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','groups','claim.name'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','true','id.token.claim'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','true','introspection.token.claim'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','String','jsonType.label'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','true','multivalued'),('eb8de553-7bb1-4474-96d4-43dc99ff4577','foo','user.attribute'),('ebc36e92-f273-4b51-8e3f-63a47047eaad','true','access.token.claim'),('ebc36e92-f273-4b51-8e3f-63a47047eaad','true','introspection.token.claim'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','true','access.token.claim'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','zoneinfo','claim.name'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','true','id.token.claim'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','true','introspection.token.claim'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','String','jsonType.label'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','zoneinfo','user.attribute'),('ede32e62-fc4f-417c-9095-85f4f26e8f79','true','userinfo.token.claim'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','true','access.token.claim'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','profile','claim.name'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','true','id.token.claim'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','true','introspection.token.claim'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','String','jsonType.label'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','profile','user.attribute'),('f0fc554f-cd4e-48e2-9198-c320e1f352e3','true','userinfo.token.claim'),('f630e460-894b-42f5-8ac7-1a7b6daef031','true','access.token.claim'),('f630e460-894b-42f5-8ac7-1a7b6daef031','true','introspection.token.claim'),('f836364b-206c-4055-a008-5657de4bc08e','true','access.token.claim'),('f836364b-206c-4055-a008-5657de4bc08e','birthdate','claim.name'),('f836364b-206c-4055-a008-5657de4bc08e','true','id.token.claim'),('f836364b-206c-4055-a008-5657de4bc08e','true','introspection.token.claim'),('f836364b-206c-4055-a008-5657de4bc08e','String','jsonType.label'),('f836364b-206c-4055-a008-5657de4bc08e','birthdate','user.attribute'),('f836364b-206c-4055-a008-5657de4bc08e','true','userinfo.token.claim'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','true','access.token.claim'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','clientHost','claim.name'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','true','id.token.claim'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','true','introspection.token.claim'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','String','jsonType.label'),('fdd8ee9d-f782-4ea9-b202-89995ac971df','clientHost','user.session.note');
/*!40000 ALTER TABLE `PROTOCOL_MAPPER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM`
--

DROP TABLE IF EXISTS `REALM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ACCESS_CODE_LIFESPAN` int DEFAULT NULL,
  `USER_ACTION_LIFESPAN` int DEFAULT NULL,
  `ACCESS_TOKEN_LIFESPAN` int DEFAULT NULL,
  `ACCOUNT_THEME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ADMIN_THEME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EMAIL_THEME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLED` tinyint NOT NULL DEFAULT '0',
  `EVENTS_ENABLED` tinyint NOT NULL DEFAULT '0',
  `EVENTS_EXPIRATION` bigint DEFAULT NULL,
  `LOGIN_THEME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NOT_BEFORE` int DEFAULT NULL,
  `PASSWORD_POLICY` text COLLATE utf8mb4_unicode_ci,
  `REGISTRATION_ALLOWED` tinyint NOT NULL DEFAULT '0',
  `REMEMBER_ME` tinyint NOT NULL DEFAULT '0',
  `RESET_PASSWORD_ALLOWED` tinyint NOT NULL DEFAULT '0',
  `SOCIAL` tinyint NOT NULL DEFAULT '0',
  `SSL_REQUIRED` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SSO_IDLE_TIMEOUT` int DEFAULT NULL,
  `SSO_MAX_LIFESPAN` int DEFAULT NULL,
  `UPDATE_PROFILE_ON_SOC_LOGIN` tinyint NOT NULL DEFAULT '0',
  `VERIFY_EMAIL` tinyint NOT NULL DEFAULT '0',
  `MASTER_ADMIN_CLIENT` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LOGIN_LIFESPAN` int DEFAULT NULL,
  `INTERNATIONALIZATION_ENABLED` tinyint NOT NULL DEFAULT '0',
  `DEFAULT_LOCALE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REG_EMAIL_AS_USERNAME` tinyint NOT NULL DEFAULT '0',
  `ADMIN_EVENTS_ENABLED` tinyint NOT NULL DEFAULT '0',
  `ADMIN_EVENTS_DETAILS_ENABLED` tinyint NOT NULL DEFAULT '0',
  `EDIT_USERNAME_ALLOWED` tinyint NOT NULL DEFAULT '0',
  `OTP_POLICY_COUNTER` int DEFAULT '0',
  `OTP_POLICY_WINDOW` int DEFAULT '1',
  `OTP_POLICY_PERIOD` int DEFAULT '30',
  `OTP_POLICY_DIGITS` int DEFAULT '6',
  `OTP_POLICY_ALG` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT 'HmacSHA1',
  `OTP_POLICY_TYPE` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT 'totp',
  `BROWSER_FLOW` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REGISTRATION_FLOW` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIRECT_GRANT_FLOW` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESET_CREDENTIALS_FLOW` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CLIENT_AUTH_FLOW` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OFFLINE_SESSION_IDLE_TIMEOUT` int DEFAULT '0',
  `REVOKE_REFRESH_TOKEN` tinyint NOT NULL DEFAULT '0',
  `ACCESS_TOKEN_LIFE_IMPLICIT` int DEFAULT '0',
  `LOGIN_WITH_EMAIL_ALLOWED` tinyint NOT NULL DEFAULT '1',
  `DUPLICATE_EMAILS_ALLOWED` tinyint NOT NULL DEFAULT '0',
  `DOCKER_AUTH_FLOW` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REFRESH_TOKEN_MAX_REUSE` int DEFAULT '0',
  `ALLOW_USER_MANAGED_ACCESS` tinyint NOT NULL DEFAULT '0',
  `SSO_MAX_LIFESPAN_REMEMBER_ME` int NOT NULL,
  `SSO_IDLE_TIMEOUT_REMEMBER_ME` int NOT NULL,
  `DEFAULT_ROLE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_ORVSDMLA56612EAEFIQ6WL5OI` (`NAME`),
  KEY `IDX_REALM_MASTER_ADM_CLI` (`MASTER_ADMIN_CLIENT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM`
--

LOCK TABLES `REALM` WRITE;
/*!40000 ALTER TABLE `REALM` DISABLE KEYS */;
INSERT INTO `REALM` (`ID`, `ACCESS_CODE_LIFESPAN`, `USER_ACTION_LIFESPAN`, `ACCESS_TOKEN_LIFESPAN`, `ACCOUNT_THEME`, `ADMIN_THEME`, `EMAIL_THEME`, `ENABLED`, `EVENTS_ENABLED`, `EVENTS_EXPIRATION`, `LOGIN_THEME`, `NAME`, `NOT_BEFORE`, `PASSWORD_POLICY`, `REGISTRATION_ALLOWED`, `REMEMBER_ME`, `RESET_PASSWORD_ALLOWED`, `SOCIAL`, `SSL_REQUIRED`, `SSO_IDLE_TIMEOUT`, `SSO_MAX_LIFESPAN`, `UPDATE_PROFILE_ON_SOC_LOGIN`, `VERIFY_EMAIL`, `MASTER_ADMIN_CLIENT`, `LOGIN_LIFESPAN`, `INTERNATIONALIZATION_ENABLED`, `DEFAULT_LOCALE`, `REG_EMAIL_AS_USERNAME`, `ADMIN_EVENTS_ENABLED`, `ADMIN_EVENTS_DETAILS_ENABLED`, `EDIT_USERNAME_ALLOWED`, `OTP_POLICY_COUNTER`, `OTP_POLICY_WINDOW`, `OTP_POLICY_PERIOD`, `OTP_POLICY_DIGITS`, `OTP_POLICY_ALG`, `OTP_POLICY_TYPE`, `BROWSER_FLOW`, `REGISTRATION_FLOW`, `DIRECT_GRANT_FLOW`, `RESET_CREDENTIALS_FLOW`, `CLIENT_AUTH_FLOW`, `OFFLINE_SESSION_IDLE_TIMEOUT`, `REVOKE_REFRESH_TOKEN`, `ACCESS_TOKEN_LIFE_IMPLICIT`, `LOGIN_WITH_EMAIL_ALLOWED`, `DUPLICATE_EMAILS_ALLOWED`, `DOCKER_AUTH_FLOW`, `REFRESH_TOKEN_MAX_REUSE`, `ALLOW_USER_MANAGED_ACCESS`, `SSO_MAX_LIFESPAN_REMEMBER_ME`, `SSO_IDLE_TIMEOUT_REMEMBER_ME`, `DEFAULT_ROLE`) VALUES ('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',60,300,54000,'keycloak.v3','keycloak.v2','flighthours',1,0,0,'flighthours','flighthours',0,'length(8) and maxLength(64) and specialChars(1) and upperCase(1)',0,0,0,0,'NONE',604800,864000,0,1,'a2ac983e-a7e0-4013-a873-c0abcef7befd',1800,0,NULL,0,0,0,0,0,1,30,6,'HmacSHA1','totp','4338d86a-1c34-4feb-8a91-d755c001a5ec','8d5e855d-5619-4fc1-a0cc-8d8167d900ba','46f43257-d304-402a-8cfd-f99957efeaf9','f825ba1c-90e7-4a24-afc6-2d3390a09c99','6bf32edd-2aa5-437e-a001-eceddcbea9da',2592000,1,900,1,0,'f9a3f1d1-0ac8-4cfc-b084-a7c9fb99d9f2',20,0,0,0,'d611ba8f-fe0b-49de-bac0-7a59e8c6a795'),('c873670d-8167-4205-af33-8519fdff5955',60,300,60,NULL,NULL,NULL,1,0,0,NULL,'master',0,NULL,0,0,0,0,'NONE',1800,36000,0,1,'28d5185c-e40e-4d11-a93d-d54349888289',1800,0,NULL,0,0,0,0,0,1,30,6,'HmacSHA1','totp','23dba624-31ac-4a4a-867f-6d43e0312d35','dd2c82f8-69f7-46b5-8a2f-b57e59e682ba','f79fe24a-8143-4ffb-a66e-966e12765245','40ae2919-d293-41e2-a2db-518bb55c1f8f','7e9039f3-defb-4cc0-8b6b-6dc158c1626d',2592000,0,900,1,0,'afd12a27-1bae-47cb-8978-31ed12fbc2c3',0,0,0,0,'0f682252-2190-4bdf-a65e-1c9cc5d1a130');
/*!40000 ALTER TABLE `REALM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_ATTRIBUTE`
--

DROP TABLE IF EXISTS `REALM_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_ATTRIBUTE` (
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`NAME`,`REALM_ID`),
  KEY `IDX_REALM_ATTR_REALM` (`REALM_ID`),
  CONSTRAINT `FK_8SHXD6L3E9ATQUKACXGPFFPTW` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_ATTRIBUTE`
--

LOCK TABLES `REALM_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `REALM_ATTRIBUTE` DISABLE KEYS */;
INSERT INTO `REALM_ATTRIBUTE` (`NAME`, `REALM_ID`, `VALUE`) VALUES ('_browser_header.contentSecurityPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','frame-src \'self\'; frame-ancestors \'self\'; object-src \'none\';'),('_browser_header.contentSecurityPolicy','c873670d-8167-4205-af33-8519fdff5955','frame-src \'self\'; frame-ancestors \'self\'; object-src \'none\';'),('_browser_header.contentSecurityPolicyReportOnly','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('_browser_header.contentSecurityPolicyReportOnly','c873670d-8167-4205-af33-8519fdff5955',''),('_browser_header.referrerPolicy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','no-referrer'),('_browser_header.referrerPolicy','c873670d-8167-4205-af33-8519fdff5955','no-referrer'),('_browser_header.strictTransportSecurity','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','max-age=31536000; includeSubDomains'),('_browser_header.strictTransportSecurity','c873670d-8167-4205-af33-8519fdff5955','max-age=31536000; includeSubDomains'),('_browser_header.xContentTypeOptions','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','nosniff'),('_browser_header.xContentTypeOptions','c873670d-8167-4205-af33-8519fdff5955','nosniff'),('_browser_header.xFrameOptions','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','SAMEORIGIN'),('_browser_header.xFrameOptions','c873670d-8167-4205-af33-8519fdff5955','SAMEORIGIN'),('_browser_header.xRobotsTag','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','none'),('_browser_header.xRobotsTag','c873670d-8167-4205-af33-8519fdff5955','none'),('acr.loa.map','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','{}'),('actionTokenGeneratedByAdminLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','43200'),('actionTokenGeneratedByAdminLifespan','c873670d-8167-4205-af33-8519fdff5955','43200'),('actionTokenGeneratedByUserLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','300'),('actionTokenGeneratedByUserLifespan','c873670d-8167-4205-af33-8519fdff5955','300'),('actionTokenGeneratedByUserLifespan.execute-actions','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('actionTokenGeneratedByUserLifespan.idp-verify-account-via-email','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('actionTokenGeneratedByUserLifespan.reset-credentials','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('actionTokenGeneratedByUserLifespan.verify-email','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('adminPermissionsEnabled','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('adminPermissionsEnabled','c873670d-8167-4205-af33-8519fdff5955','false'),('bruteForceProtected','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('bruteForceProtected','c873670d-8167-4205-af33-8519fdff5955','false'),('bruteForceStrategy','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','MULTIPLE'),('bruteForceStrategy','c873670d-8167-4205-af33-8519fdff5955','MULTIPLE'),('cibaAuthRequestedUserHint','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','login_hint'),('cibaAuthRequestedUserHint','c873670d-8167-4205-af33-8519fdff5955','login_hint'),('cibaBackchannelTokenDeliveryMode','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','poll'),('cibaBackchannelTokenDeliveryMode','c873670d-8167-4205-af33-8519fdff5955','poll'),('cibaExpiresIn','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','120'),('cibaExpiresIn','c873670d-8167-4205-af33-8519fdff5955','120'),('cibaInterval','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','5'),('cibaInterval','c873670d-8167-4205-af33-8519fdff5955','5'),('client-policies.policies','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','{\"policies\":[]}'),('client-policies.policies','c873670d-8167-4205-af33-8519fdff5955','{\"policies\":[]}'),('client-policies.profiles','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','{\"profiles\":[]}'),('client-policies.profiles','c873670d-8167-4205-af33-8519fdff5955','{\"profiles\":[]}'),('clientOfflineSessionIdleTimeout','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('clientOfflineSessionIdleTimeout','c873670d-8167-4205-af33-8519fdff5955','0'),('clientOfflineSessionMaxLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('clientOfflineSessionMaxLifespan','c873670d-8167-4205-af33-8519fdff5955','0'),('clientSessionIdleTimeout','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('clientSessionIdleTimeout','c873670d-8167-4205-af33-8519fdff5955','0'),('clientSessionMaxLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('clientSessionMaxLifespan','c873670d-8167-4205-af33-8519fdff5955','0'),('darkMode','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','true'),('defaultSignatureAlgorithm','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','RS256'),('defaultSignatureAlgorithm','c873670d-8167-4205-af33-8519fdff5955','RS256'),('displayName','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','FlightHours'),('displayName','c873670d-8167-4205-af33-8519fdff5955','Keycloak'),('displayNameHtml','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('displayNameHtml','c873670d-8167-4205-af33-8519fdff5955','<div class=\"kc-logo-text\"><span>Keycloak</span></div>'),('failureFactor','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','30'),('failureFactor','c873670d-8167-4205-af33-8519fdff5955','30'),('firstBrokerLoginFlowId','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ae22e362-db0c-4a6a-9510-ef529c77ab4f'),('firstBrokerLoginFlowId','c873670d-8167-4205-af33-8519fdff5955','4e68aab5-fd13-4708-9542-80fde2dbc31b'),('frontendUrl','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('maxDeltaTimeSeconds','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','43200'),('maxDeltaTimeSeconds','c873670d-8167-4205-af33-8519fdff5955','43200'),('maxFailureWaitSeconds','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','900'),('maxFailureWaitSeconds','c873670d-8167-4205-af33-8519fdff5955','900'),('maxTemporaryLockouts','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('maxTemporaryLockouts','c873670d-8167-4205-af33-8519fdff5955','0'),('minimumQuickLoginWaitSeconds','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','60'),('minimumQuickLoginWaitSeconds','c873670d-8167-4205-af33-8519fdff5955','60'),('oauth2DeviceCodeLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','600'),('oauth2DeviceCodeLifespan','c873670d-8167-4205-af33-8519fdff5955','600'),('oauth2DevicePollingInterval','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','7'),('oauth2DevicePollingInterval','c873670d-8167-4205-af33-8519fdff5955','5'),('offlineSessionMaxLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','5184000'),('offlineSessionMaxLifespan','c873670d-8167-4205-af33-8519fdff5955','5184000'),('offlineSessionMaxLifespanEnabled','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('offlineSessionMaxLifespanEnabled','c873670d-8167-4205-af33-8519fdff5955','false'),('organizationsEnabled','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('organizationsEnabled','c873670d-8167-4205-af33-8519fdff5955','false'),('parRequestUriLifespan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','60'),('parRequestUriLifespan','c873670d-8167-4205-af33-8519fdff5955','60'),('permanentLockout','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('permanentLockout','c873670d-8167-4205-af33-8519fdff5955','false'),('quickLoginCheckMilliSeconds','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','1000'),('quickLoginCheckMilliSeconds','c873670d-8167-4205-af33-8519fdff5955','1000'),('realmReusableOtpCode','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('realmReusableOtpCode','c873670d-8167-4205-af33-8519fdff5955','false'),('saml.signature.algorithm','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('shortVerificationUri','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('verifiableCredentialsEnabled','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('verifiableCredentialsEnabled','c873670d-8167-4205-af33-8519fdff5955','false'),('waitIncrementSeconds','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','60'),('waitIncrementSeconds','c873670d-8167-4205-af33-8519fdff5955','60'),('webAuthnPolicyAttestationConveyancePreference','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','not specified'),('webAuthnPolicyAttestationConveyancePreference','c873670d-8167-4205-af33-8519fdff5955','not specified'),('webAuthnPolicyAttestationConveyancePreferencePasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','not specified'),('webAuthnPolicyAttestationConveyancePreferencePasswordless','c873670d-8167-4205-af33-8519fdff5955','not specified'),('webAuthnPolicyAuthenticatorAttachment','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','not specified'),('webAuthnPolicyAuthenticatorAttachment','c873670d-8167-4205-af33-8519fdff5955','not specified'),('webAuthnPolicyAuthenticatorAttachmentPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','not specified'),('webAuthnPolicyAuthenticatorAttachmentPasswordless','c873670d-8167-4205-af33-8519fdff5955','not specified'),('webAuthnPolicyAvoidSameAuthenticatorRegister','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('webAuthnPolicyAvoidSameAuthenticatorRegister','c873670d-8167-4205-af33-8519fdff5955','false'),('webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false'),('webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless','c873670d-8167-4205-af33-8519fdff5955','false'),('webAuthnPolicyCreateTimeout','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('webAuthnPolicyCreateTimeout','c873670d-8167-4205-af33-8519fdff5955','0'),('webAuthnPolicyCreateTimeoutPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','0'),('webAuthnPolicyCreateTimeoutPasswordless','c873670d-8167-4205-af33-8519fdff5955','0'),('webAuthnPolicyRequireResidentKey','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','not specified'),('webAuthnPolicyRequireResidentKey','c873670d-8167-4205-af33-8519fdff5955','not specified'),('webAuthnPolicyRequireResidentKeyPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','Yes'),('webAuthnPolicyRequireResidentKeyPasswordless','c873670d-8167-4205-af33-8519fdff5955','Yes'),('webAuthnPolicyRpEntityName','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','keycloak'),('webAuthnPolicyRpEntityName','c873670d-8167-4205-af33-8519fdff5955','keycloak'),('webAuthnPolicyRpEntityNamePasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','keycloak'),('webAuthnPolicyRpEntityNamePasswordless','c873670d-8167-4205-af33-8519fdff5955','keycloak'),('webAuthnPolicyRpId','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('webAuthnPolicyRpId','c873670d-8167-4205-af33-8519fdff5955',''),('webAuthnPolicyRpIdPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',''),('webAuthnPolicyRpIdPasswordless','c873670d-8167-4205-af33-8519fdff5955',''),('webAuthnPolicySignatureAlgorithms','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ES256,RS256'),('webAuthnPolicySignatureAlgorithms','c873670d-8167-4205-af33-8519fdff5955','ES256,RS256'),('webAuthnPolicySignatureAlgorithmsPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','ES256,RS256'),('webAuthnPolicySignatureAlgorithmsPasswordless','c873670d-8167-4205-af33-8519fdff5955','ES256,RS256'),('webAuthnPolicyUserVerificationRequirement','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','not specified'),('webAuthnPolicyUserVerificationRequirement','c873670d-8167-4205-af33-8519fdff5955','not specified'),('webAuthnPolicyUserVerificationRequirementPasswordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','required'),('webAuthnPolicyUserVerificationRequirementPasswordless','c873670d-8167-4205-af33-8519fdff5955','required');
/*!40000 ALTER TABLE `REALM_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_DEFAULT_GROUPS`
--

DROP TABLE IF EXISTS `REALM_DEFAULT_GROUPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_DEFAULT_GROUPS` (
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `GROUP_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`GROUP_ID`),
  UNIQUE KEY `CON_GROUP_ID_DEF_GROUPS` (`GROUP_ID`),
  KEY `IDX_REALM_DEF_GRP_REALM` (`REALM_ID`),
  CONSTRAINT `FK_DEF_GROUPS_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_DEFAULT_GROUPS`
--

LOCK TABLES `REALM_DEFAULT_GROUPS` WRITE;
/*!40000 ALTER TABLE `REALM_DEFAULT_GROUPS` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_DEFAULT_GROUPS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_ENABLED_EVENT_TYPES`
--

DROP TABLE IF EXISTS `REALM_ENABLED_EVENT_TYPES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_ENABLED_EVENT_TYPES` (
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`VALUE`),
  KEY `IDX_REALM_EVT_TYPES_REALM` (`REALM_ID`),
  CONSTRAINT `FK_H846O4H0W8EPX5NWEDRF5Y69J` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_ENABLED_EVENT_TYPES`
--

LOCK TABLES `REALM_ENABLED_EVENT_TYPES` WRITE;
/*!40000 ALTER TABLE `REALM_ENABLED_EVENT_TYPES` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_ENABLED_EVENT_TYPES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_EVENTS_LISTENERS`
--

DROP TABLE IF EXISTS `REALM_EVENTS_LISTENERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_EVENTS_LISTENERS` (
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`VALUE`),
  KEY `IDX_REALM_EVT_LIST_REALM` (`REALM_ID`),
  CONSTRAINT `FK_H846O4H0W8EPX5NXEV9F5Y69J` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_EVENTS_LISTENERS`
--

LOCK TABLES `REALM_EVENTS_LISTENERS` WRITE;
/*!40000 ALTER TABLE `REALM_EVENTS_LISTENERS` DISABLE KEYS */;
INSERT INTO `REALM_EVENTS_LISTENERS` (`REALM_ID`, `VALUE`) VALUES ('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','jboss-logging'),('c873670d-8167-4205-af33-8519fdff5955','jboss-logging');
/*!40000 ALTER TABLE `REALM_EVENTS_LISTENERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_LOCALIZATIONS`
--

DROP TABLE IF EXISTS `REALM_LOCALIZATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_LOCALIZATIONS` (
  `REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LOCALE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TEXTS` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`LOCALE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_LOCALIZATIONS`
--

LOCK TABLES `REALM_LOCALIZATIONS` WRITE;
/*!40000 ALTER TABLE `REALM_LOCALIZATIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_LOCALIZATIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_REQUIRED_CREDENTIAL`
--

DROP TABLE IF EXISTS `REALM_REQUIRED_CREDENTIAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_REQUIRED_CREDENTIAL` (
  `TYPE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FORM_LABEL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INPUT` tinyint NOT NULL DEFAULT '0',
  `SECRET` tinyint NOT NULL DEFAULT '0',
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`TYPE`),
  CONSTRAINT `FK_5HG65LYBEVAVKQFKI3KPONH9V` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_REQUIRED_CREDENTIAL`
--

LOCK TABLES `REALM_REQUIRED_CREDENTIAL` WRITE;
/*!40000 ALTER TABLE `REALM_REQUIRED_CREDENTIAL` DISABLE KEYS */;
INSERT INTO `REALM_REQUIRED_CREDENTIAL` (`TYPE`, `FORM_LABEL`, `INPUT`, `SECRET`, `REALM_ID`) VALUES ('password','password',1,1,'b75562a5-cbdd-4128-b49f-fe9e41a3cbbc'),('password','password',1,1,'c873670d-8167-4205-af33-8519fdff5955');
/*!40000 ALTER TABLE `REALM_REQUIRED_CREDENTIAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_SMTP_CONFIG`
--

DROP TABLE IF EXISTS `REALM_SMTP_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_SMTP_CONFIG` (
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`NAME`),
  CONSTRAINT `FK_70EJ8XDXGXD0B9HH6180IRR0O` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_SMTP_CONFIG`
--

LOCK TABLES `REALM_SMTP_CONFIG` WRITE;
/*!40000 ALTER TABLE `REALM_SMTP_CONFIG` DISABLE KEYS */;
INSERT INTO `REALM_SMTP_CONFIG` (`REALM_ID`, `VALUE`, `NAME`) VALUES ('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','','allowutf8'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','true','auth'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','basic','authType'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false','debug'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','','envelopeFrom'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','noreply_flighthours@rbsuport.com','from'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','Flighthours','fromDisplayName'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','smtp.resend.com','host'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','re_6w3aQQUe_EQaL4h4X3QpUizqcxbG725a8','password'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','587','port'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','','replyTo'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','','replyToDisplayName'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','false','ssl'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','true','starttls'),('b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','resend','user'),('c873670d-8167-4205-af33-8519fdff5955','','allowutf8'),('c873670d-8167-4205-af33-8519fdff5955','true','auth'),('c873670d-8167-4205-af33-8519fdff5955','basic','authType'),('c873670d-8167-4205-af33-8519fdff5955','false','debug'),('c873670d-8167-4205-af33-8519fdff5955','','envelopeFrom'),('c873670d-8167-4205-af33-8519fdff5955','noreply_flighthours@rbsuport.com','from'),('c873670d-8167-4205-af33-8519fdff5955','flighthours','fromDisplayName'),('c873670d-8167-4205-af33-8519fdff5955','smtp.resend.com','host'),('c873670d-8167-4205-af33-8519fdff5955','re_6w3aQQUe_EQaL4h4X3QpUizqcxbG725a8','password'),('c873670d-8167-4205-af33-8519fdff5955','587','port'),('c873670d-8167-4205-af33-8519fdff5955','sara@yopmail.com','replyTo'),('c873670d-8167-4205-af33-8519fdff5955','','replyToDisplayName'),('c873670d-8167-4205-af33-8519fdff5955','false','ssl'),('c873670d-8167-4205-af33-8519fdff5955','true','starttls'),('c873670d-8167-4205-af33-8519fdff5955','resend','user');
/*!40000 ALTER TABLE `REALM_SMTP_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_SUPPORTED_LOCALES`
--

DROP TABLE IF EXISTS `REALM_SUPPORTED_LOCALES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_SUPPORTED_LOCALES` (
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`VALUE`),
  KEY `IDX_REALM_SUPP_LOCAL_REALM` (`REALM_ID`),
  CONSTRAINT `FK_SUPPORTED_LOCALES_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_SUPPORTED_LOCALES`
--

LOCK TABLES `REALM_SUPPORTED_LOCALES` WRITE;
/*!40000 ALTER TABLE `REALM_SUPPORTED_LOCALES` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_SUPPORTED_LOCALES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REDIRECT_URIS`
--

DROP TABLE IF EXISTS `REDIRECT_URIS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REDIRECT_URIS` (
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`VALUE`),
  KEY `IDX_REDIR_URI_CLIENT` (`CLIENT_ID`),
  CONSTRAINT `FK_1BURS8PB4OUJ97H5WUPPAHV9F` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REDIRECT_URIS`
--

LOCK TABLES `REDIRECT_URIS` WRITE;
/*!40000 ALTER TABLE `REDIRECT_URIS` DISABLE KEYS */;
INSERT INTO `REDIRECT_URIS` (`CLIENT_ID`, `VALUE`) VALUES ('474ae4f8-f457-4bdc-8188-f31b5c2da25d','/realms/master/account/*'),('4a9e15c1-378e-4a7d-a299-5a5a0823034d','/admin/master/console/*'),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','/admin/flighthours/console/*'),('80ea558e-f66c-4b77-bce0-5424629e49bf','/realms/flighthours/account/*'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','http://localhost:8081/*'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','http://localhost:8082/*'),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','/realms/flighthours/account/*'),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','/realms/master/account/*');
/*!40000 ALTER TABLE `REDIRECT_URIS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQUIRED_ACTION_CONFIG`
--

DROP TABLE IF EXISTS `REQUIRED_ACTION_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REQUIRED_ACTION_CONFIG` (
  `REQUIRED_ACTION_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`REQUIRED_ACTION_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQUIRED_ACTION_CONFIG`
--

LOCK TABLES `REQUIRED_ACTION_CONFIG` WRITE;
/*!40000 ALTER TABLE `REQUIRED_ACTION_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `REQUIRED_ACTION_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQUIRED_ACTION_PROVIDER`
--

DROP TABLE IF EXISTS `REQUIRED_ACTION_PROVIDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REQUIRED_ACTION_PROVIDER` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ALIAS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLED` tinyint NOT NULL DEFAULT '0',
  `DEFAULT_ACTION` tinyint NOT NULL DEFAULT '0',
  `PROVIDER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_REQ_ACT_PROV_REALM` (`REALM_ID`),
  CONSTRAINT `FK_REQ_ACT_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQUIRED_ACTION_PROVIDER`
--

LOCK TABLES `REQUIRED_ACTION_PROVIDER` WRITE;
/*!40000 ALTER TABLE `REQUIRED_ACTION_PROVIDER` DISABLE KEYS */;
INSERT INTO `REQUIRED_ACTION_PROVIDER` (`ID`, `ALIAS`, `NAME`, `REALM_ID`, `ENABLED`, `DEFAULT_ACTION`, `PROVIDER_ID`, `PRIORITY`) VALUES ('0983b985-76e2-4365-a115-c485d70d9d9b','UPDATE_PROFILE','Update Profile','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'UPDATE_PROFILE',40),('1095de0d-bf31-4503-92c3-6cb07b449feb','UPDATE_PROFILE','Update Profile','c873670d-8167-4205-af33-8519fdff5955',1,0,'UPDATE_PROFILE',40),('221f5f27-ea86-4174-9307-46dcb3292f0d','TERMS_AND_CONDITIONS','Terms and Conditions','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'TERMS_AND_CONDITIONS',20),('264c527a-e454-46d0-af7e-035a7e81baf3','update_user_locale','Update User Locale','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'update_user_locale',1000),('2678a043-b94c-4382-a442-81b84d5f6ae1','update_user_locale','Update User Locale','c873670d-8167-4205-af33-8519fdff5955',1,0,'update_user_locale',1000),('2aa18e5e-930a-4607-b61a-3b6adc46b475','UPDATE_EMAIL','Update Email','c873670d-8167-4205-af33-8519fdff5955',0,0,'UPDATE_EMAIL',70),('36257a17-2fe4-4a84-b9ea-1c41793c9e02','CONFIGURE_TOTP','Configure OTP','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'CONFIGURE_TOTP',10),('43b51b76-95a8-4bf0-8577-b50872674bbb','CONFIGURE_RECOVERY_AUTHN_CODES','Recovery Authentication Codes','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'CONFIGURE_RECOVERY_AUTHN_CODES',130),('43d30e2b-be4c-4b2c-96a2-f7dff6578103','VERIFY_EMAIL','Verify Email','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'VERIFY_EMAIL',50),('58d4f4e9-4a63-46ce-913d-39a430d86c51','CONFIGURE_TOTP','Configure OTP','c873670d-8167-4205-af33-8519fdff5955',1,0,'CONFIGURE_TOTP',10),('5afaad17-d50e-4005-ad93-79c225c41064','UPDATE_PASSWORD','Update Password','c873670d-8167-4205-af33-8519fdff5955',1,0,'UPDATE_PASSWORD',30),('5e8f7871-1206-455f-9b56-5af3ba6a01c0','VERIFY_PROFILE','Verify Profile','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'VERIFY_PROFILE',100),('60c5fa36-d465-450b-8f75-0db78a232321','delete_credential','Delete Credential','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'delete_credential',110),('631cc3bb-ab71-4a15-b271-00ec4a575794','UPDATE_EMAIL','Update Email','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'UPDATE_EMAIL',70),('66744607-f5be-4ed8-a510-3173ef5ac05f','TERMS_AND_CONDITIONS','Terms and Conditions','c873670d-8167-4205-af33-8519fdff5955',0,0,'TERMS_AND_CONDITIONS',20),('76ba4552-9321-48f7-833c-6a096b7981e2','UPDATE_PASSWORD','Update Password','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'UPDATE_PASSWORD',30),('82c43580-b45d-4a9a-b901-4348f94e12ef','VERIFY_PROFILE','Verify Profile','c873670d-8167-4205-af33-8519fdff5955',1,0,'VERIFY_PROFILE',100),('97a5477c-01d4-4c56-8f35-3c1bbd702960','webauthn-register-passwordless','Webauthn Register Passwordless','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'webauthn-register-passwordless',90),('9d18d740-95ce-4aad-898c-59580abd3b15','idp_link','Linking Identity Provider','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'idp_link',120),('a3ec4145-7c89-4ca3-94fa-03ef04a74b93','idp_link','Linking Identity Provider','c873670d-8167-4205-af33-8519fdff5955',1,0,'idp_link',120),('c87e26e7-919a-4665-93b4-02b13a312a86','CONFIGURE_RECOVERY_AUTHN_CODES','Recovery Authentication Codes','c873670d-8167-4205-af33-8519fdff5955',1,0,'CONFIGURE_RECOVERY_AUTHN_CODES',130),('cd8e4ace-83fb-4d15-b88e-e96de817cfda','delete_credential','Delete Credential','c873670d-8167-4205-af33-8519fdff5955',1,0,'delete_credential',110),('d128c114-a1e5-4f6b-8fd7-8c7f07831c7d','VERIFY_EMAIL','Verify Email','c873670d-8167-4205-af33-8519fdff5955',1,0,'VERIFY_EMAIL',50),('d7e42618-f2e2-4a11-9b9c-c46650ba99e6','webauthn-register','Webauthn Register','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',1,0,'webauthn-register',80),('e10d90eb-0584-45ed-9345-f2c6f0010196','webauthn-register-passwordless','Webauthn Register Passwordless','c873670d-8167-4205-af33-8519fdff5955',1,0,'webauthn-register-passwordless',90),('ea898c6c-f999-47ca-a134-f0d945443d3c','webauthn-register','Webauthn Register','c873670d-8167-4205-af33-8519fdff5955',1,0,'webauthn-register',80),('f3fd11e3-b043-4efc-b181-de35485d5452','delete_account','Delete Account','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc',0,0,'delete_account',60),('fea31454-8af2-4129-b53a-e687830fe504','delete_account','Delete Account','c873670d-8167-4205-af33-8519fdff5955',0,0,'delete_account',60);
/*!40000 ALTER TABLE `REQUIRED_ACTION_PROVIDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_ATTRIBUTE`
--

DROP TABLE IF EXISTS `RESOURCE_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_ATTRIBUTE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sybase-needs-something-here',
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_5HRM2VLF9QL5FU022KQEPOVBR` (`RESOURCE_ID`),
  CONSTRAINT `FK_5HRM2VLF9QL5FU022KQEPOVBR` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_ATTRIBUTE`
--

LOCK TABLES `RESOURCE_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_POLICY`
--

DROP TABLE IF EXISTS `RESOURCE_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_POLICY` (
  `RESOURCE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `POLICY_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`POLICY_ID`),
  KEY `IDX_RES_POLICY_POLICY` (`POLICY_ID`),
  CONSTRAINT `FK_FRSRPOS53XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`),
  CONSTRAINT `FK_FRSRPP213XCX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_POLICY`
--

LOCK TABLES `RESOURCE_POLICY` WRITE;
/*!40000 ALTER TABLE `RESOURCE_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SCOPE`
--

DROP TABLE IF EXISTS `RESOURCE_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SCOPE` (
  `RESOURCE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`SCOPE_ID`),
  KEY `IDX_RES_SCOPE_SCOPE` (`SCOPE_ID`),
  CONSTRAINT `FK_FRSRPOS13XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`),
  CONSTRAINT `FK_FRSRPS213XCX4WNKOG82SSRFY` FOREIGN KEY (`SCOPE_ID`) REFERENCES `RESOURCE_SERVER_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SCOPE`
--

LOCK TABLES `RESOURCE_SCOPE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ALLOW_RS_REMOTE_MGMT` tinyint NOT NULL DEFAULT '0',
  `POLICY_ENFORCE_MODE` tinyint DEFAULT NULL,
  `DECISION_STRATEGY` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER`
--

LOCK TABLES `RESOURCE_SERVER` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_PERM_TICKET`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_PERM_TICKET`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_PERM_TICKET` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `OWNER` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REQUESTER` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_TIMESTAMP` bigint NOT NULL,
  `GRANTED_TIMESTAMP` bigint DEFAULT NULL,
  `RESOURCE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `POLICY_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSR6T700S9V50BU18WS5PMT` (`OWNER`,`REQUESTER`,`RESOURCE_SERVER_ID`,`RESOURCE_ID`,`SCOPE_ID`),
  KEY `FK_FRSRHO213XCX4WNKOG82SSPMT` (`RESOURCE_SERVER_ID`),
  KEY `FK_FRSRHO213XCX4WNKOG83SSPMT` (`RESOURCE_ID`),
  KEY `FK_FRSRHO213XCX4WNKOG84SSPMT` (`SCOPE_ID`),
  KEY `FK_FRSRPO2128CX4WNKOG82SSRFY` (`POLICY_ID`),
  KEY `IDX_PERM_TICKET_REQUESTER` (`REQUESTER`),
  KEY `IDX_PERM_TICKET_OWNER` (`OWNER`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG82SSPMT` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG83SSPMT` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG84SSPMT` FOREIGN KEY (`SCOPE_ID`) REFERENCES `RESOURCE_SERVER_SCOPE` (`ID`),
  CONSTRAINT `FK_FRSRPO2128CX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_PERM_TICKET`
--

LOCK TABLES `RESOURCE_SERVER_PERM_TICKET` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_PERM_TICKET` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_PERM_TICKET` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_POLICY`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_POLICY` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TYPE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DECISION_STRATEGY` tinyint DEFAULT NULL,
  `LOGIC` tinyint DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNER` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSRPT700S9V50BU18WS5HA6` (`NAME`,`RESOURCE_SERVER_ID`),
  KEY `IDX_RES_SERV_POL_RES_SERV` (`RESOURCE_SERVER_ID`),
  CONSTRAINT `FK_FRSRPO213XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_POLICY`
--

LOCK TABLES `RESOURCE_SERVER_POLICY` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_RESOURCE`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_RESOURCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_RESOURCE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ICON_URI` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNER` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNER_MANAGED_ACCESS` tinyint NOT NULL DEFAULT '0',
  `DISPLAY_NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSR6T700S9V50BU18WS5HA6` (`NAME`,`OWNER`,`RESOURCE_SERVER_ID`),
  KEY `IDX_RES_SRV_RES_RES_SRV` (`RESOURCE_SERVER_ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_RESOURCE`
--

LOCK TABLES `RESOURCE_SERVER_RESOURCE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_RESOURCE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_RESOURCE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_SCOPE`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_SCOPE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ICON_URI` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DISPLAY_NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSRST700S9V50BU18WS5HA6` (`NAME`,`RESOURCE_SERVER_ID`),
  KEY `IDX_RES_SRV_SCOPE_RES_SRV` (`RESOURCE_SERVER_ID`),
  CONSTRAINT `FK_FRSRSO213XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_SCOPE`
--

LOCK TABLES `RESOURCE_SERVER_SCOPE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_URIS`
--

DROP TABLE IF EXISTS `RESOURCE_URIS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_URIS` (
  `RESOURCE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`VALUE`),
  CONSTRAINT `FK_RESOURCE_SERVER_URIS` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_URIS`
--

LOCK TABLES `RESOURCE_URIS` WRITE;
/*!40000 ALTER TABLE `RESOURCE_URIS` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_URIS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REVOKED_TOKEN`
--

DROP TABLE IF EXISTS `REVOKED_TOKEN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REVOKED_TOKEN` (
  `ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `EXPIRE` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_REV_TOKEN_ON_EXPIRE` (`EXPIRE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REVOKED_TOKEN`
--

LOCK TABLES `REVOKED_TOKEN` WRITE;
/*!40000 ALTER TABLE `REVOKED_TOKEN` DISABLE KEYS */;
/*!40000 ALTER TABLE `REVOKED_TOKEN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROLE_ATTRIBUTE`
--

DROP TABLE IF EXISTS `ROLE_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ROLE_ATTRIBUTE` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ROLE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_ROLE_ATTRIBUTE` (`ROLE_ID`),
  CONSTRAINT `FK_ROLE_ATTRIBUTE_ID` FOREIGN KEY (`ROLE_ID`) REFERENCES `KEYCLOAK_ROLE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROLE_ATTRIBUTE`
--

LOCK TABLES `ROLE_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `ROLE_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ROLE_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SCOPE_MAPPING`
--

DROP TABLE IF EXISTS `SCOPE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SCOPE_MAPPING` (
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ROLE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`ROLE_ID`),
  KEY `IDX_SCOPE_MAPPING_ROLE` (`ROLE_ID`),
  CONSTRAINT `FK_OUSE064PLMLR732LXJCN1Q5F1` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SCOPE_MAPPING`
--

LOCK TABLES `SCOPE_MAPPING` WRITE;
/*!40000 ALTER TABLE `SCOPE_MAPPING` DISABLE KEYS */;
INSERT INTO `SCOPE_MAPPING` (`CLIENT_ID`, `ROLE_ID`) VALUES ('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','0be0f161-0bfa-4df1-b7b0-c83a1c88ec75'),('9cdd7cb4-b5e3-4f8d-b9a2-d8516e35b6ae','37868fcb-9b2c-4408-a496-b0c22ea8b916'),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','68310cb2-f6c3-4949-85c4-c3c76c285dd5'),('f2fa0263-8f33-4398-9630-fcf973ed4dc5','ba12455a-29fc-4a9f-88c3-f4df58d641bb');
/*!40000 ALTER TABLE `SCOPE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SCOPE_POLICY`
--

DROP TABLE IF EXISTS `SCOPE_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SCOPE_POLICY` (
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `POLICY_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCOPE_ID`,`POLICY_ID`),
  KEY `IDX_SCOPE_POLICY_POLICY` (`POLICY_ID`),
  CONSTRAINT `FK_FRSRASP13XCX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`),
  CONSTRAINT `FK_FRSRPASS3XCX4WNKOG82SSRFY` FOREIGN KEY (`SCOPE_ID`) REFERENCES `RESOURCE_SERVER_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SCOPE_POLICY`
--

LOCK TABLES `SCOPE_POLICY` WRITE;
/*!40000 ALTER TABLE `SCOPE_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `SCOPE_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SERVER_CONFIG`
--

DROP TABLE IF EXISTS `SERVER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SERVER_CONFIG` (
  `SERVER_CONFIG_KEY` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `VERSION` int DEFAULT '0',
  PRIMARY KEY (`SERVER_CONFIG_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SERVER_CONFIG`
--

LOCK TABLES `SERVER_CONFIG` WRITE;
/*!40000 ALTER TABLE `SERVER_CONFIG` DISABLE KEYS */;
INSERT INTO `SERVER_CONFIG` (`SERVER_CONFIG_KEY`, `VALUE`, `VERSION`) VALUES ('crt_jgroups','{\"prvKey\":\"MIIEowIBAAKCAQEApQoy6e7elCYezGJdNJaHFnLqqqUeKPVWwU/aXYSimfpHzim4gSQDAKI2eus+N2ZHsP2+A+bpO8swTX5iZkB3C4G1rg5p7k16ioEiViV0gEPymIYazzDDBdQzOazBc0pm/FzbN8eiC4OzWuME916EwdQH1AL8kKGAvsFNiYtaYkx8oV8RVQ8MmKr189H0IL/FeYzXMTUJV5Du4Z70JA5rJJjuegjuYYhzzWgMmfr1cGYvPiIK9vG4T5aJ4SowCvt3ji/qC6FePvPScK1FB+3JPn5mtidokwnoU8c/D+FrtEAIY1Q3XDRZddBRRy970Lr4KHIvA+2jnmSFX3/2qjquPwIDAQABAoIBAAObcD6hsDtI2nzCZVWkppvsf/pMmXJeupKfmGUQcQCCsmREqI3S+7J7uqzFnveGM8pQy73zL6tPHFZHK6uMs2RAllmFAV5U/WzJaQwSKRL2nQklxEKrRuhSKNebFPKrl/4G3sXqvPoHTsLKbHU+zCpCv8Nu3oQTyg+nXzm8mEyiG7lN6fTSytRjUPm2UmwFM48tk6yQTZwtEaTMQnPjSuFrQUxLONu/pJTnt/ZhwulJ4LsQbGxhLthOD2K1KyWYH2lQLvqw5f/o4kLfp8/mvS7ekeppKGYjeASqTCqnBQ/8Ru62dv149gIyRb2pr+nwYUyh9FVoGY4m6BvLG0Ub+O0CgYEA1ktAK1mJuNzhqpy+KW6XIouJlUt7iTbNu5bSXDJMMhCKh2WaAuQHZqhWgY3eGIWLfLk8fxgB9d3EwzL+hMUmM4ZS/and88q0bPfvBNQk9m6NCvgtXCG895h467X8bxmSSwkvztkfJKaET9Op5qR0GZGbtkG419VMFJKRcXEIhfsCgYEAxSj3BLW1EsqxH5UkbD/EtGkbAcEQweJALe7fkdiFAGUKCDNHvXmX4rPvlrJ+2fsZp5BPu+wYl1DJMGJJG3iEFl3H4C3R8o3gZa5St52co5Bbs46NOHhAcLFcPqmeBq8YIISrpo1QDAd0Sd7BEN4Ut5MneN5Zfdkj6tKCnO3cOY0CgYEAsAb8XR+du9blIErFAi+vwlaw24w3nA0Cjldj0QwX/wALaxEQo9NAKRmaha1NhQMeA4P9p8DGy3oyCM44uENiD+0E+w2wHnSiJOi81FCXVD6XaS1XxViJazE6ExVYmMJ+o1iWhulfZbHK+e+6npT0MZSkPeBawCCb8EI9atwYzkUCgYAKyDK6DzXX0T3efEmBofsf4p+XePdxou3flTCkyTJ80wm5aRSDSCMGQtDXbOuDADhm8X1qyX6Ox9w4ySc2WWDf2EEWAWt52EhtRxs+71+hkkNxjloqvGjJwOlKg/wgYXLwVFEOyquV/NJfN89XHM4FPAbslTxPpZBRRzHdYySoAQKBgHO+zwskJzfJpV/MMYALqYczpvtkoKHbgLwA6RYn1HQ3GOpQmfoK6qHr8ZxV5MvTKYZwE/w+qulR/OEMeZORfdkJ/f99jtqKBq8atcVONiAfgL/FGpy5G1ggllM6fskndG8MCpbrm0IiIRJyUS5H9WL2AQUXEk6NgQUl2jUDdl5K\",\"pubKey\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApQoy6e7elCYezGJdNJaHFnLqqqUeKPVWwU/aXYSimfpHzim4gSQDAKI2eus+N2ZHsP2+A+bpO8swTX5iZkB3C4G1rg5p7k16ioEiViV0gEPymIYazzDDBdQzOazBc0pm/FzbN8eiC4OzWuME916EwdQH1AL8kKGAvsFNiYtaYkx8oV8RVQ8MmKr189H0IL/FeYzXMTUJV5Du4Z70JA5rJJjuegjuYYhzzWgMmfr1cGYvPiIK9vG4T5aJ4SowCvt3ji/qC6FePvPScK1FB+3JPn5mtidokwnoU8c/D+FrtEAIY1Q3XDRZddBRRy970Lr4KHIvA+2jnmSFX3/2qjquPwIDAQAB\",\"crt\":\"MIICnTCCAYUCBgGckA0H2jANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdqZ3JvdXBzMB4XDTI2MDIyNDE0MjYzOVoXDTI2MDQyNTE0MjgxOFowEjEQMA4GA1UEAwwHamdyb3VwczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKUKMunu3pQmHsxiXTSWhxZy6qqlHij1VsFP2l2Eopn6R84puIEkAwCiNnrrPjdmR7D9vgPm6TvLME1+YmZAdwuBta4Oae5NeoqBIlYldIBD8piGGs8wwwXUMzmswXNKZvxc2zfHoguDs1rjBPdehMHUB9QC/JChgL7BTYmLWmJMfKFfEVUPDJiq9fPR9CC/xXmM1zE1CVeQ7uGe9CQOaySY7noI7mGIc81oDJn69XBmLz4iCvbxuE+WieEqMAr7d44v6guhXj7z0nCtRQftyT5+ZrYnaJMJ6FPHPw/ha7RACGNUN1w0WXXQUUcve9C6+ChyLwPto55khV9/9qo6rj8CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAh04HBj85cr+eU7bWFBFHw9AFPa0Me3qksAi/zRg2birPslaBaRjGZkmieHvUNHV32EL64gDg4xe5VNtEjoZf3I1Mh9ImBC6Y6xGGwOHi38nPbZV9M3SggUPEmWoRPdpZ8/VQRMIPMU6ll6GxIGsDTVJmvfIc8rgQ0mQFa7eI6M9hbXyAluvR42cZwgDAAKtco6zZhrATmNZ9ojrE/b1KOkMLVLO7K9ngJrIqMSnJwR1+IIsy8qKIUhpb65MpPEqwie0IJWCkK4gY0iIPpxexDctlsHMerLEqCx/UFk3ApshMj+G7JswzkL1svnDZpdIWZYq6np637C8t63r4YU6qkA==\",\"alias\":\"bc5cf9f2-d547-4538-b28f-279acac62efb\",\"generatedMillis\":1771943299080}',2),('JGROUPS_ADDRESS_SEQUENCE','95',95);
/*!40000 ALTER TABLE `SERVER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ATTRIBUTE`
--

DROP TABLE IF EXISTS `USER_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ATTRIBUTE` (
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sybase-needs-something-here',
  `LONG_VALUE_HASH` binary(64) DEFAULT NULL,
  `LONG_VALUE_HASH_LOWER_CASE` binary(64) DEFAULT NULL,
  `LONG_VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`ID`),
  KEY `IDX_USER_ATTRIBUTE` (`USER_ID`),
  KEY `IDX_USER_ATTRIBUTE_NAME` (`NAME`,`VALUE`),
  KEY `USER_ATTR_LONG_VALUES` (`LONG_VALUE_HASH`,`NAME`),
  KEY `USER_ATTR_LONG_VALUES_LOWER_CASE` (`LONG_VALUE_HASH_LOWER_CASE`,`NAME`),
  CONSTRAINT `FK_5HRM2VLF9QL5FU043KQEPOVBR` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ATTRIBUTE`
--

LOCK TABLES `USER_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `USER_ATTRIBUTE` DISABLE KEYS */;
INSERT INTO `USER_ATTRIBUTE` (`NAME`, `VALUE`, `USER_ID`, `ID`, `LONG_VALUE_HASH`, `LONG_VALUE_HASH_LOWER_CASE`, `LONG_VALUE`) VALUES ('is_temporary_admin','true','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee','ebad48e0-7bdc-45b3-92d5-02377662cf3f',NULL,NULL,NULL);
/*!40000 ALTER TABLE `USER_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_CONSENT`
--

DROP TABLE IF EXISTS `USER_CONSENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_CONSENT` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `LAST_UPDATED_DATE` bigint DEFAULT NULL,
  `CLIENT_STORAGE_PROVIDER` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EXTERNAL_CLIENT_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_LOCAL_CONSENT` (`CLIENT_ID`,`USER_ID`),
  UNIQUE KEY `UK_EXTERNAL_CONSENT` (`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`,`USER_ID`),
  KEY `IDX_USER_CONSENT` (`USER_ID`),
  CONSTRAINT `FK_GRNTCSNT_USER` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_CONSENT`
--

LOCK TABLES `USER_CONSENT` WRITE;
/*!40000 ALTER TABLE `USER_CONSENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_CONSENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_CONSENT_CLIENT_SCOPE`
--

DROP TABLE IF EXISTS `USER_CONSENT_CLIENT_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_CONSENT_CLIENT_SCOPE` (
  `USER_CONSENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SCOPE_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`USER_CONSENT_ID`,`SCOPE_ID`),
  KEY `IDX_USCONSENT_CLSCOPE` (`USER_CONSENT_ID`),
  KEY `IDX_USCONSENT_SCOPE_ID` (`SCOPE_ID`),
  CONSTRAINT `FK_GRNTCSNT_CLSC_USC` FOREIGN KEY (`USER_CONSENT_ID`) REFERENCES `USER_CONSENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_CONSENT_CLIENT_SCOPE`
--

LOCK TABLES `USER_CONSENT_CLIENT_SCOPE` WRITE;
/*!40000 ALTER TABLE `USER_CONSENT_CLIENT_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_CONSENT_CLIENT_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ENTITY`
--

DROP TABLE IF EXISTS `USER_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ENTITY` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `EMAIL` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EMAIL_CONSTRAINT` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EMAIL_VERIFIED` tinyint NOT NULL DEFAULT '0',
  `ENABLED` tinyint NOT NULL DEFAULT '0',
  `FEDERATION_LINK` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIRST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REALM_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_TIMESTAMP` bigint DEFAULT NULL,
  `SERVICE_ACCOUNT_CLIENT_LINK` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NOT_BEFORE` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_DYKN684SL8UP1CRFEI6ECKHD7` (`REALM_ID`,`EMAIL_CONSTRAINT`),
  UNIQUE KEY `UK_RU8TT6T700S9V50BU18WS5HA6` (`REALM_ID`,`USERNAME`),
  KEY `IDX_USER_EMAIL` (`EMAIL`),
  KEY `IDX_USER_SERVICE_ACCOUNT` (`REALM_ID`,`SERVICE_ACCOUNT_CLIENT_LINK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ENTITY`
--

LOCK TABLES `USER_ENTITY` WRITE;
/*!40000 ALTER TABLE `USER_ENTITY` DISABLE KEYS */;
INSERT INTO `USER_ENTITY` (`ID`, `EMAIL`, `EMAIL_CONSTRAINT`, `EMAIL_VERIFIED`, `ENABLED`, `FEDERATION_LINK`, `FIRST_NAME`, `LAST_NAME`, `REALM_ID`, `USERNAME`, `CREATED_TIMESTAMP`, `SERVICE_ACCOUNT_CLIENT_LINK`, `NOT_BEFORE`) VALUES ('1586d5b4-8691-4e6c-9a70-48f06fb8fb06','juan@yopmail.com','juan@yopmail.com',1,1,NULL,'Juan','Juan','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','juan@yopmail.com',1770070853751,NULL,0),('616357a0-a6e4-4514-94c7-f734eda2a685','josedalogo@yopmail.com','josedalogo@yopmail.com',1,1,NULL,'Jose David','Jose David','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','josedalogo@yopmail.com',1769523197080,NULL,0),('66faf137-c364-4fa3-b82a-1585327fb009','laura@yopmail.com','laura@yopmail.com',1,1,NULL,'Laura','Laura','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','laura@yopmail.com',1769959914431,NULL,0),('a17ebaf6-e6fb-4fca-89e3-60a38d3670ee','emma@yopmail.com','emma@yopmail.com',1,1,NULL,'emmanuel','gomez','c873670d-8167-4205-af33-8519fdff5955','admin',1765919074690,NULL,0),('fb2b2b63-df46-4b1a-8244-ffa990c06ccc','emmalondogo@gmail.com','emmalondogo@gmail.com',1,1,NULL,'Emma','Gomez','b75562a5-cbdd-4128-b49f-fe9e41a3cbbc','admin',1765925540154,NULL,0);
/*!40000 ALTER TABLE `USER_ENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_CONFIG`
--

DROP TABLE IF EXISTS `USER_FEDERATION_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_CONFIG` (
  `USER_FEDERATION_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`USER_FEDERATION_PROVIDER_ID`,`NAME`),
  CONSTRAINT `FK_T13HPU1J94R2EBPEKR39X5EU5` FOREIGN KEY (`USER_FEDERATION_PROVIDER_ID`) REFERENCES `USER_FEDERATION_PROVIDER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_CONFIG`
--

LOCK TABLES `USER_FEDERATION_CONFIG` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_MAPPER`
--

DROP TABLE IF EXISTS `USER_FEDERATION_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_MAPPER` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FEDERATION_PROVIDER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FEDERATION_MAPPER_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_USR_FED_MAP_FED_PRV` (`FEDERATION_PROVIDER_ID`),
  KEY `IDX_USR_FED_MAP_REALM` (`REALM_ID`),
  CONSTRAINT `FK_FEDMAPPERPM_FEDPRV` FOREIGN KEY (`FEDERATION_PROVIDER_ID`) REFERENCES `USER_FEDERATION_PROVIDER` (`ID`),
  CONSTRAINT `FK_FEDMAPPERPM_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_MAPPER`
--

LOCK TABLES `USER_FEDERATION_MAPPER` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_MAPPER_CONFIG`
--

DROP TABLE IF EXISTS `USER_FEDERATION_MAPPER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_MAPPER_CONFIG` (
  `USER_FEDERATION_MAPPER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`USER_FEDERATION_MAPPER_ID`,`NAME`),
  CONSTRAINT `FK_FEDMAPPER_CFG` FOREIGN KEY (`USER_FEDERATION_MAPPER_ID`) REFERENCES `USER_FEDERATION_MAPPER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_MAPPER_CONFIG`
--

LOCK TABLES `USER_FEDERATION_MAPPER_CONFIG` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_PROVIDER`
--

DROP TABLE IF EXISTS `USER_FEDERATION_PROVIDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_PROVIDER` (
  `ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CHANGED_SYNC_PERIOD` int DEFAULT NULL,
  `DISPLAY_NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FULL_SYNC_PERIOD` int DEFAULT NULL,
  `LAST_SYNC` int DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  `PROVIDER_NAME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REALM_ID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_USR_FED_PRV_REALM` (`REALM_ID`),
  CONSTRAINT `FK_1FJ32F6PTOLW2QY60CD8N01E8` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_PROVIDER`
--

LOCK TABLES `USER_FEDERATION_PROVIDER` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_PROVIDER` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_PROVIDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_GROUP_MEMBERSHIP`
--

DROP TABLE IF EXISTS `USER_GROUP_MEMBERSHIP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_GROUP_MEMBERSHIP` (
  `GROUP_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MEMBERSHIP_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`GROUP_ID`,`USER_ID`),
  KEY `IDX_USER_GROUP_MAPPING` (`USER_ID`),
  CONSTRAINT `FK_USER_GROUP_USER` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_GROUP_MEMBERSHIP`
--

LOCK TABLES `USER_GROUP_MEMBERSHIP` WRITE;
/*!40000 ALTER TABLE `USER_GROUP_MEMBERSHIP` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_GROUP_MEMBERSHIP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_REQUIRED_ACTION`
--

DROP TABLE IF EXISTS `USER_REQUIRED_ACTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_REQUIRED_ACTION` (
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REQUIRED_ACTION` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ' ',
  PRIMARY KEY (`REQUIRED_ACTION`,`USER_ID`),
  KEY `IDX_USER_REQACTIONS` (`USER_ID`),
  CONSTRAINT `FK_6QJ3W1JW9CVAFHE19BWSIUVMD` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_REQUIRED_ACTION`
--

LOCK TABLES `USER_REQUIRED_ACTION` WRITE;
/*!40000 ALTER TABLE `USER_REQUIRED_ACTION` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_REQUIRED_ACTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `USER_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ROLE_MAPPING` (
  `ROLE_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `USER_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`USER_ID`),
  KEY `IDX_USER_ROLE_MAPPING` (`USER_ID`),
  CONSTRAINT `FK_C4FQV34P1MBYLLOXANG7B1Q3L` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ROLE_MAPPING`
--

LOCK TABLES `USER_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `USER_ROLE_MAPPING` DISABLE KEYS */;
INSERT INTO `USER_ROLE_MAPPING` (`ROLE_ID`, `USER_ID`) VALUES ('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','1586d5b4-8691-4e6c-9a70-48f06fb8fb06'),('ff884dea-c46e-4419-b751-b0592f7103af','1586d5b4-8691-4e6c-9a70-48f06fb8fb06'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','616357a0-a6e4-4514-94c7-f734eda2a685'),('ff884dea-c46e-4419-b751-b0592f7103af','616357a0-a6e4-4514-94c7-f734eda2a685'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','66faf137-c364-4fa3-b82a-1585327fb009'),('ff884dea-c46e-4419-b751-b0592f7103af','66faf137-c364-4fa3-b82a-1585327fb009'),('0f682252-2190-4bdf-a65e-1c9cc5d1a130','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('1cc06174-b1b7-477c-8491-be1481b24dc3','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('21641986-3ae5-4971-8e21-81147a237896','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('31aa74c8-be92-4599-a411-c2e4d0e701ab','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('48577b46-6b30-4169-ac2c-85edd8cfc11c','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('4e0868e7-ca25-45be-a018-a8ce2d8aa842','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('517d4f3b-2c0a-4859-858e-e8210273d456','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('65d829ba-a5c6-4c13-84d6-5d2d57a3920a','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('68310cb2-f6c3-4949-85c4-c3c76c285dd5','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('731a8627-3f6c-4a47-847a-18ab45194f00','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('7ca1f358-ef99-4274-a4ff-d33fc146a115','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('8c0e76d1-d061-4871-95e2-52df7f44ee8a','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('8c7d8cde-93d3-42dd-aed4-8002001e61fe','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('9ebef503-961f-4745-8da6-e9cbdc1caa49','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('9f8b76f3-5e25-4c2c-868e-26e9526e54b6','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('a675b148-ea75-435d-82c6-24f12ada704d','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('ba12455a-29fc-4a9f-88c3-f4df58d641bb','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('bb2916e1-3e7e-4094-874a-f5b0986267d3','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('ddacf774-0aef-4361-9e41-4b35ac252eea','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('deb4ef45-876d-4ab5-bcd0-febe09244597','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('e7c320d9-b58f-49d2-9ae9-58fdded3abaa','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('f22df1db-e246-4c6f-983a-2e0bac7f2db6','a17ebaf6-e6fb-4fca-89e3-60a38d3670ee'),('026c9e72-b023-465c-bf75-bdc8516b26c6','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('0be0f161-0bfa-4df1-b7b0-c83a1c88ec75','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('10fc5f89-ed70-4bd5-834c-6fe55da79eb9','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('23239c07-76bf-4e99-bd63-28350366b303','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('35cedb35-3ef6-4343-a0fd-61766d82ef4a','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('37868fcb-9b2c-4408-a496-b0c22ea8b916','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('39d99fb9-d8c9-416e-a3ca-ba7481555919','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('3d726bac-5a8f-46bd-9629-7e5c8d180138','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('3f98208c-06a0-4d22-a3f2-689d2300e576','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('54a22128-248a-4632-bdfb-3462a684a4f3','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('585558bf-1a85-4955-9343-172c7b92ad8f','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('5b2ad3b7-b067-4fbf-9b43-5fd86d3896ab','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('5dcce07d-25b0-4a2c-b5a6-e8fa23fc5e66','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('75ae6bc7-9d48-4be6-b9b5-7a0b6c7f4a61','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('7d6f7d58-447b-4807-bf0d-e52855574c88','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('80add76c-f7f2-4bad-ab92-eae1fd77853c','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('88686a44-1f56-45e9-afec-72f8013c91b4','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('8a33dbd8-cc74-4b3c-aadc-c841b23883e7','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('a934b7f0-714e-4c21-bcf2-c603daa4313c','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('a94d1665-92ef-4f2b-9b64-37a83fea21e2','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('b3c65021-7052-41a1-b994-bd522a35bcea','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('b9c9053f-8b22-405f-9f5c-fe26dd836334','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('bb400aff-c02a-4b6f-905c-6f0b67c2ca56','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('bc29392a-51f8-4455-9d7a-cc374cbbaf8f','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('bd8be41b-0953-4a2d-a536-81bab39e561a','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('d611ba8f-fe0b-49de-bac0-7a59e8c6a795','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('dc18ea96-139f-49b2-8465-4ca3fc89b567','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('f5ca9c99-8f3f-41b0-819a-afaaa960b598','fb2b2b63-df46-4b1a-8244-ffa990c06ccc'),('f730dd50-853d-4aaf-b092-119b362f0974','fb2b2b63-df46-4b1a-8244-ffa990c06ccc');
/*!40000 ALTER TABLE `USER_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WEB_ORIGINS`
--

DROP TABLE IF EXISTS `WEB_ORIGINS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WEB_ORIGINS` (
  `CLIENT_ID` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`VALUE`),
  KEY `IDX_WEB_ORIG_CLIENT` (`CLIENT_ID`),
  CONSTRAINT `FK_LOJPHO213XCX4WNKOG82SSRFY` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WEB_ORIGINS`
--

LOCK TABLES `WEB_ORIGINS` WRITE;
/*!40000 ALTER TABLE `WEB_ORIGINS` DISABLE KEYS */;
INSERT INTO `WEB_ORIGINS` (`CLIENT_ID`, `VALUE`) VALUES ('4a9e15c1-378e-4a7d-a299-5a5a0823034d','+'),('6632f16a-9ca9-4fc9-a2af-9f2cefe78778','+'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','http://localhost:8081'),('8ecfbb96-b50c-41c4-8161-8d1b4aad085b','http://localhost:8082');
/*!40000 ALTER TABLE `WEB_ORIGINS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WORKFLOW_STATE`
--

DROP TABLE IF EXISTS `WORKFLOW_STATE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WORKFLOW_STATE` (
  `EXECUTION_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RESOURCE_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `WORKFLOW_ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `WORKFLOW_PROVIDER_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESOURCE_TYPE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SCHEDULED_STEP_ID` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SCHEDULED_STEP_TIMESTAMP` bigint DEFAULT NULL,
  PRIMARY KEY (`EXECUTION_ID`),
  UNIQUE KEY `UQ_WORKFLOW_RESOURCE` (`WORKFLOW_ID`,`RESOURCE_ID`),
  KEY `IDX_WORKFLOW_STATE_STEP` (`WORKFLOW_ID`,`SCHEDULED_STEP_ID`),
  KEY `IDX_WORKFLOW_STATE_PROVIDER` (`RESOURCE_ID`,`WORKFLOW_PROVIDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WORKFLOW_STATE`
--

LOCK TABLES `WORKFLOW_STATE` WRITE;
/*!40000 ALTER TABLE `WORKFLOW_STATE` DISABLE KEYS */;
/*!40000 ALTER TABLE `WORKFLOW_STATE` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-05 21:37:17
