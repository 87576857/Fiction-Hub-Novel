package com.novel.test;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.novel.dao.TestMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class DbConnectionTest {

    @Autowired
    private TestMapper testMapper;

    @Test
    public void testDbConnection() {
        String result = testMapper.testConnection();
        System.out.println("조회 결과: " + result);
        assertEquals("DB 연결 성공", result);
    }
}