# coding: utf-8

require 'spec_helper'

describe PrivacyMaskTools::EmailMatcher do
  class Obj
    include PrivacyMaskTools::EmailMatcher
  end

  let!(:matcher) { Obj.new }

  # @see http://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9
  let!(:rfc_emails) { ["Abc.123@example.com",
    "user+mailbox/department=shipping@example.com",
    "!#$\%&'*+-/=?^_`.{|}~@example.com",
    "\"Abc@def\"@example.com",
    "\"Fred Bloggs\"@example.com"]
    # "\"Joe.\\\\Blow\"@example.com" # これは諦め
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

    context "Emailが含まれていない場合" do
      subject { matcher.pick_rfc_email("testtest") }
      its(:size) { should eql 0 }
    end
  end

  describe ".rfc_email_masking" do
    context "正しいEmailが1つだけ含まれている場合" do
      subject { matcher.rfc_email_masking("私のメールアドレスは#{rfc_emails[0]}です") }
      it { should eql "私のメールアドレスは***です" }
    end

    context "正しいEmailが2つ以上含まれている場合" do
      subject { matcher.rfc_email_masking(rfc_emails.join("　デス\r\nよ"), "+++") }
      it { should eql (["+++"]*5).join("　デス\r\nよ") }
    end

    context "Emailが含まれていない場合" do
      subject { matcher.rfc_email_masking("testtest＠hoge.com") }
      it { should eql "testtest＠hoge.com" }
    end
  end

  describe ".special_char" do
    subject { matcher.special_char }
    it { should be_kind_of(String) }
  end

  describe ".quoted_special_char" do
    subject { matcher.quoted_special_char }
    it { should be_kind_of(String) }
  end

  describe ".unquoted_regexp" do
    subject { matcher.special_char }
    it { should be_kind_of(String) }
  end

  describe ".quoted_regexp" do
    subject { matcher.quoted_regexp }
    it { should be_kind_of(String) }
  end

  describe ".domain_regexp" do
    subject { matcher.domain_regexp }
    it { should be_kind_of(String) }
  end
end

