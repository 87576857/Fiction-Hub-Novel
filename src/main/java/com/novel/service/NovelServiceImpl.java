package com.novel.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.novel.dao.NovelMapper;
import com.novel.domain.Novel;

@Service
public class NovelServiceImpl implements NovelService {

	@Autowired
	private NovelMapper novelMapper;

	@Override
	public List<Novel> getNovelList() {
		return getNovelList(null);
	}

	@Override
	public List<Novel> getNovelList(String keyword) {
		return novelMapper.selectAllNovels(keyword);
	}

	@Override
	public List<Novel> getNovelPage(int page, int pageSize) {
		return getNovelPage(page, pageSize, null);
	}

	@Override
	public List<Novel> getNovelPage(int page, int pageSize, String platform) {
		return getNovelPage(page, pageSize, platform, null);
	}

	@Override
	public List<Novel> getNovelPage(int page, int pageSize, String platform, String sort) {
		return getNovelPage(page, pageSize, platform, sort, null);
	}

	@Override
	public List<Novel> getNovelPage(int page, int pageSize, String platform, String sort, String keyword) {
		int safePage = Math.max(page, 1);
		int offset = (safePage - 1) * pageSize;
		return novelMapper.selectNovelsPaged(offset, pageSize, platform, sort, keyword);
	}

	@Override
	public int countAllNovels() {
		return countAllNovels(null);
	}

	@Override
	public int countAllNovels(String platform) {
		return countAllNovels(platform, null);
	}

	@Override
	public int countAllNovels(String platform, String keyword) {
		return novelMapper.countAllNovels(platform, keyword);
	}

	@Override
	public List<Novel> getTopNovels(int limit) {
		return novelMapper.selectTopNovelsByViewCount(limit);
	}

	@Override
	@Transactional
	public Novel getNovelDetail(int novelId) {
		novelMapper.increaseViewCount(novelId);
		return novelMapper.selectNovelById(novelId);
	}

	@Override
	public Novel getNovelById(int novelId) {
		return novelMapper.selectNovelById(novelId);
	}

	@Override
	public void registerNovel(Novel novel) {
		novelMapper.insertNovel(novel);
	}

	@Override
	public void updateNovel(Novel novel) {
		novelMapper.updateNovel(novel);
	}

	@Override
	public void deleteNovel(int novelId) {
		novelMapper.deleteNovel(novelId);
	}
}
