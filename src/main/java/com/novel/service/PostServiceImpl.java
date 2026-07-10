package com.novel.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.novel.dao.BoardMapper;
import com.novel.dao.CommentMapper;
import com.novel.dao.NovelReviewMapper;
import com.novel.dao.PostMapper;
import com.novel.domain.Comment;
import com.novel.domain.Post;

@Service
public class PostServiceImpl implements PostService {

	@Autowired
	private BoardMapper boardMapper;

	@Autowired
	private PostMapper postMapper;

	@Autowired
	private CommentMapper commentMapper;

	@Autowired
	private NovelReviewMapper novelReviewMapper;

	@Override
	public List<Post> getPostList(String boardName, String tag, String keyword) {
		int boardId = boardMapper.selectBoardIdByName(boardName);
		return postMapper.selectPostsByBoard(boardId, tag, keyword);
	}

	@Override
	public List<Post> getPopularPosts(int limit) {
		return postMapper.selectTopPostsByView(limit);
	}

	@Override
	public Map<String, List<Post>> getTopPostsByBoard(int limit) {
		List<Post> topPosts = postMapper.selectTopPostsPerBoard(limit);
		Map<String, List<Post>> result = new LinkedHashMap<>();
		for (Post post : topPosts) {
			result.computeIfAbsent(post.getBoardKey(), k -> new java.util.ArrayList<>()).add(post);
		}
		return result;
	}

	@Override
	@Transactional
	public Post getPostDetail(int postId) {
		postMapper.increaseViewCount(postId);
		return postMapper.selectPostById(postId);
	}

	@Override
	public Post getPostById(int postId) {
		return postMapper.selectPostById(postId);
	}

	@Override
	public List<Comment> getComments(int postId) {
		return commentMapper.selectCommentsByPost(postId);
	}

	@Override
	public void writePost(String boardName, Post post) {
		int boardId = boardMapper.selectBoardIdByName(boardName);
		post.setBoardId(boardId);
		postMapper.insertPost(post);
	}

	@Override
	public void writeComment(Comment comment) {
		commentMapper.insertComment(comment);
	}

	@Override
	public void toggleSolved(int postId, boolean solved) {
		postMapper.updateSolved(postId, solved);
	}

	@Override
	public List<Post> getMyPosts(int userId) {
		return postMapper.selectPostsByUser(userId);
	}

	@Override
	public List<Comment> getMyComments(int userId) {
		// 게시판 댓글 + 소설 리뷰를 하나의 목록으로 합쳐서 최신순으로 노출
		List<Comment> comments = commentMapper.selectCommentsByUser(userId);
		List<Comment> reviews = novelReviewMapper.selectReviewsAsCommentsByUser(userId);
		List<Comment> merged = new ArrayList<>(comments.size() + reviews.size());
		merged.addAll(comments);
		merged.addAll(reviews);
		merged.sort(Comparator.comparing(Comment::getCreatedAt).reversed());
		return merged;
	}

	@Override
	public boolean deleteMyComment(int commentId, String type, int userId) {
		if ("review".equals(type)) {
			return novelReviewMapper.deleteReviewByIdAndUser(commentId, userId) > 0;
		}
		return commentMapper.deleteCommentByIdAndUser(commentId, userId) > 0;
	}

	@Override
	public boolean updateMyPost(int postId, int userId, String title, String content, String tag) {
		return postMapper.updatePostByIdAndUser(postId, userId, title, content, tag) > 0;
	}
}
