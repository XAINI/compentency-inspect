QuestionBank::TestPaperResult.class_eval do
  def question_answer_status(question)
    qr = self.question_records.where(user_id: user.id, question_id: question.id).first

    if qr.blank?
      return {
        answer: nil,
        is_correct: false,
        filled: false
      }
    end

    if qr.kind == "bool"
      return {
        answer: qr.answer,
        is_correct: qr.is_correct,
        filled: !qr.answer.nil?
      }
    end

    return {
      answer: qr.answer,
      is_correct: qr.is_correct,
      filled: qr.answer.present?
    }
  end

  def review_status(reviewer)
    review = QuestionBank::TestPaperResultReview.where(
      user_id: reviewer.id,
      test_paper_result_id: self.id
    ).first

    if review.blank?
      return {
        comment: nil,
        status: nil
      }
    end

    return {
      comment: review.comment,
      status: review.status
    }

  end

  def question_review_status(question, reviewer)
    review = QuestionBank::TestPaperResultReview.where(
      user_id: reviewer.id,
      test_paper_result_id: self.id
    ).first

    if review.blank?
      return {
        score: nil,
        comment: nil
      }
    end

    review.question_review_status(question, reviewer)
  end

  def review(reviewer)
    review = QuestionBank::TestPaperResultReview.where(
      user_id: reviewer.id,
      test_paper_result_id: self.id
    ).first

    if review.blank?
      review = QuestionBank::TestPaperResultReview.create(
        user_id: reviewer.id,
        test_paper_result_id: self.id
      )
    end
    review
  end
end
