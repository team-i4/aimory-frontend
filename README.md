
![ReadmeIntro](https://github.com/user-attachments/assets/3960d9f0-f0db-454e-862e-dd9ebf0242cc)
# 📱 프로젝트명 - 아이모리 어린이집 업무 자동화 서비스 앱
서비스 시연 영상 : https://drive.google.com/file/d/1KhTtFkvpSvPPk7qbjWElONgx0cxTZ0VN/view?usp=sharing
기간 : 2024.12.16 ~ 2025.2.7 (8주)
   

## 📌 프로젝트 소개
아이모리(Ai-mory)는 **인공지능을 활용한 어린이집 원아 기록 애플리케이션**으로, 
AI와 Memory를 결합한 이름을 가집니다. 
이 서비스는 공지사항, 알림장, 사진첩 기능을 제공하여 
**교사의 업무 효율성을 높이고 학부모와 교사 간의 소통을 강화**하는 것을 목표로 합니다.




## 🎯 주요 기능
✔ **REST API 연동**   
✔ **JWT 로그인**   
✔ **갤러리를 활용한 사진첩 기능**  
✔ **OpenAI ChatGPT API 연동**  




## 📂 폴더 구조
```bash
aimory_app/
 ├── android/               
 ├── ios/                   
 ├── assets/                
 ├── lib/                   # 메인 프로젝트 폴더
 │   ├── core/              # 앱의 핵심 기능 및 공통 요소
 │   │   ├── const/         # 상수 데이터
 │   │   ├── screens/       # 공통 화면 컴포넌트
 │   │   ├── util/          # 유틸리티 함수
 │   │   ├── widgets/       # 재사용 위젯
 │   ├── features/          # 주요 기능별 폴더
 │   │   ├── auth/          # 인증 관련 기능
 │   │   │   ├── models/    # 모델
 │   │   │   ├── providers/ # 상태 관리
 │   │   │   ├── screens/   
 │   │   │   ├── services/  # 서비스
 │   │   ├── home/          # 홈 화면
 │   │   ├── notes/         # 알림장 기능
 │   │   ├── notices/       # 공지사항 기능
 │   │   ├── photos/        # 사진 업로드 및 관리
 │   │   ├── search/        # 검색 기능
 │   ├── main.dart          
 ├── .dart_tool/            
 ├── .idea/                 
 ├── build/
 ```

 ## 🔧 기술 스택
### 📱 **Frontend**
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=materialdesign&logoColor=white)

### 🗄️ **State Management**
![Provider](https://img.shields.io/badge/Provider-2196F3?style=for-the-badge&logo=dart&logoColor=white)
![Flutter Riverpod](https://img.shields.io/badge/Riverpod-0055AA?style=for-the-badge&logo=dart&logoColor=white)

### 🔗 **Networking & API**
![Dio](https://img.shields.io/badge/Dio-FFCD00?style=for-the-badge&logo=dart&logoColor=white)
![HTTP](https://img.shields.io/badge/HTTP-008080?style=for-the-badge&logo=http&logoColor=white)
![Retrofit](https://img.shields.io/badge/Retrofit-9C27B0?style=for-the-badge&logo=dart&logoColor=white)

### 🔒 **Authentication & Security**
![Flutter Secure Storage](https://img.shields.io/badge/Secure%20Storage-4CAF50?style=for-the-badge&logo=flutter&logoColor=white)

### 🛠 **Development & Tools**
![Flutter Lints](https://img.shields.io/badge/Flutter%20Lints-FF4081?style=for-the-badge&logo=lint&logoColor=white)
![Build Runner](https://img.shields.io/badge/Build%20Runner-673AB7?style=for-the-badge&logo=codeigniter&logoColor=white)
![JSON Serializable](https://img.shields.io/badge/JSON%20Serializable-3DDC84?style=for-the-badge&logo=json&logoColor=white)

## 📸 스크린샷

![aimory_login](https://github.com/user-attachments/assets/33a0415f-d434-4b87-ba70-a73fce94c883)
![aimory_teacher_home](https://github.com/user-attachments/assets/0c1383ab-9fb2-4578-bcbb-971fca0ed2b4)
![aimory_notice](https://github.com/user-attachments/assets/bcf0b2bd-4de6-451e-a662-e16b7cdd1564)
![aimory_note](https://github.com/user-attachments/assets/2e0bf8f5-cb4b-45e0-b9cd-a26bd1de22a3)
![aimory_photo](https://github.com/user-attachments/assets/03d699c7-83d2-45d2-a34b-8213a593a121)
![aimory_search](https://github.com/user-attachments/assets/6eb5dcce-11c4-423b-ab2f-29e72e27e53e)
![aimory_mypage](https://github.com/user-attachments/assets/22771f60-6ebb-4948-b337-49030f5b6608)

## 📜 배포 계획
추후 고도화 작업을 거쳐 Google Play 스토어 배포 예정입니다.

## 배포 전 고도화 작업 TODO
- 유저 원장 Role 추가하여 필요 스크린 생성
- 공지사항/알림장 검색창 추가(기존 AI를 활용한 데이터 기반 검색 기능 삭제)
- 공지사항/알림장 PUSH 알림
- 알림장 AI 본문 생성기 기능 추가


## 백엔드 레포지토리
https://github.com/team-i4/aimory-backend


