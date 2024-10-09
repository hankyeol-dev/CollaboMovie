//
//  TrendingRequestDTO+Mapping.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct TrendingRequestDTO: Encodable {
    let language: String = "ko-KR"
}

extension TrendingRequestDTO {
    var asParameters: [String: Any] {
        return JSONEncoder.toDictionary(self)
    }
}

/*
 "backdrop_path": "/o0NsbcIvsllg6CJX0FBFY8wWbsn.jpg",
       "id": 30984,
       "name": "블리치",
       "original_name": "BLEACH",
       "overview": "'쿠로사키 이치고'는 유령을 볼 수 있는 15세의 남자다. 특수한 체질을 가지고도 평범한 생활을 하던 이치고에게 갑자기 스스로를 사신이라고 소개하는 소녀 '쿠치키 루키아'가 나타난다. 유아울러 산 사람, 죽은 사람 안 가리고 공격해서 영혼을 먹어치우는 나쁜 혼령 '호로'도 모습을 드러낸다. 그런데 호로로 인해 이치고의 가족이 쓰러져가는데...",
       "poster_path": "/2cT8jkEVsAL86CVKALR4pnaVLDb.jpg",
       "media_type": "tv",
       "adult": false,
       "original_language": "ja",
       "genre_ids": [
         10759,
         16,
         10765
       ],
       "popularity": 491.475,
       "first_air_date": "2004-10-05",
       "vote_average": 8.384,
       "vote_count": 1799,
       "origin_country": [
         "JP"
       ]
 
 "backdrop_path": "/A1dZ6faTjg0e6HYftBmEKujuXGQ.jpg",
       "id": 917496,
       "title": "비틀쥬스 비틀쥬스",
       "original_title": "Beetlejuice Beetlejuice",
       "overview": "유령과 대화하는 영매로 유명세를 타게 된 리디아와 그런 엄마가 마음에 들지 않는 10대 딸 아스트리드. 할아버지 찰스의 갑작스러운 죽음으로 가족들은 함께 시골 마을에 내려간다. 유령을 보는 엄마가 마음에 들지 않는 아스트리드는 방황하던 중 함정에 빠져 저세상에 발을 들이게 되고 딸을 구하기 위해 리디아는 인간을 믿지 않는 저세상 슈퍼스타 비틀쥬스를 소환한다. 이루지 못한 리디아와의 결혼을 조건으로 내민 비틀쥬스. 이번엔 아스트리드가 비틀쥬스를 다시 저세상으로 보내야 하는데···",
       "poster_path": "/ypWQatJYyESE5PIzdlSdiOyWYja.jpg",
       "media_type": "movie",
       "adult": false,
       "original_language": "en",
       "genre_ids": [
         35,
         14,
         27
       ],
       "popularity": 1216.533,
       "release_date": "2024-09-04",
       "video": false,
       "vote_average": 7.2,
       "vote_count": 885
 */
