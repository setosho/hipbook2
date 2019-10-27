class FeedMailer < ApplicationMailer
  def feed_mail(feed)
    @feed = feed
    mail to: "@feed.autor_email", subject: "画像投稿確認メール" if @feed.present?
  end
end
