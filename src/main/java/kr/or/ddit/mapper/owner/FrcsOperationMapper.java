package kr.or.ddit.mapper.owner;

import java.util.Date;

import org.apache.ibatis.annotations.Param;

public interface FrcsOperationMapper {

	public int getSumPublicDues(@Param("frcsId")String frcsId, @Param("thisMonth")Date thisMonth);

	// 인건비
	public int getPay(String frcsId);

}
