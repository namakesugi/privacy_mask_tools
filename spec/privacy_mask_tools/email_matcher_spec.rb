# coding: utf-8

require 'spec_helper'

describe PrivacyMaskTools::EmailMatcher do
  class Obj
    include PrivacyMaskTools::EmailMatcher
  end

  let!(:matcher) { Obj.new }

  # @see http://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9
  let!(:rfc_emails) { [].tap { |o|
    o << "Abc.123@example.com"
    o << "user+mailbox/department=shipping@example.com"
    o << "!#$\%&'*+-/=?^_`.{|}~@example.com"
    o << "\"Abc@def\"@example.com"
    o << "\"Fred Bloggs\"@example.com" #    o << "\"Joe.\\\\Blow\"@example.com" # これは諦め
    }
  }
  describe ".has_rfc_email?" do
    context "正しいEmailの場合" do
      it { rfc_emails.each { |f| matcher.has_rfc_email?(f).should be_true } }
    end
    context "文章中にメールアドレスが含まれている場合" do
      it { matcher.has_rfc_email?("メールアドレスはxxxxx@example.comです").should be_true }
      it { matcher.has_rfc_email?("メールアドレスは\r\nxxxxx@example.comです").should be_true }
    end
  end

  describe ".pick_rfc_email" do
    context "正しいEmailが1つだけ含まれている場合" do
      subject { matcher.pick_rfc_email("私のメールアドレスは#{rfc_emails[0]}です") }
      its(:size) { should eql 1 }
      its([0]) { should eql rfc_emails[0] }
    end

    context "正しいEmailが2つ以上含まれている場合" do
      subject { matcher.pick_rfc_email(rfc_emails.join("　デス\r\nよ")) }
      its(:size) { should eql 5 }
      its([0]) { should eql rfc_emails[0] }
      its([1]) { should eql rfc_emails[1] }
      its([2]) { should eql rfc_emails[2] }
      its([3]) { should eql rfc_emails[3] }
      its([4]) { should eql rfc_emails[4] }
    end
  end
end

