package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.test;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface testmapper {

	@Select("SELECT text FROM test LIMIT 1")
    String GetString();
}
