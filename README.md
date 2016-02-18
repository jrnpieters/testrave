# headless testrave
headless ./testscripts and cool stories



== UI Test Project Layout

TBC

== Prerequisites

capybara-webkit: https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit
qt: https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit
xvfb: yum / apt-get install Xvfb
Ruby http://www.ruby-lang.org/en/downloads/
Ruby Gems http://rubygems.org/
Bundler: sudo gem install bundler rake
== Configuration

bundle install

== Running Features

To run all features: DISPLAY=localhost:1.0 xvfb-run bundle exec cucumber

To run a specific feature: DISPLAY=localhost:1.0 xvfb-run bundle exec cucumber cucumber features/search.feature

== Debugging

To debug a specific step call save_and_open_page within the step
== Additional Documentation

http://cukes.info (for general cucumber information)
https://gist.github.com/zhengjia/428105 (cheetsheet)
http://github.com/jnicklas/capybara (for actions such as click_link, click_button, etc...)
