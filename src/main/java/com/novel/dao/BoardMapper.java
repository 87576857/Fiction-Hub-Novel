package com.novel.dao;

public interface BoardMapper {
	/** board_name으로 board_id 조회 (예: "이 소설 찾아요" -> 1) */
	Integer selectBoardIdByName(String boardName);
}
