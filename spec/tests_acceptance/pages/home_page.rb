# frozen_string_literal: true

# Page object for sms home page

class HomePage
  include PageObject

  page_url SMS::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h1(:title_heading, id: 'main_header')
  text_field(:query_input, id: 'query_input')
  button(:search_btn, id: 'query_button')

  indexed_property(
    :cves,
    [
      [:h2, :cve_title, { id: 'cve[%s].cve_id' }],
      [:p, :cve_overview, { id: 'cve[%s].overview' }],
      [:a, :cve_link, { id: 'cve[%s].link' }]
    ]
  )
  div(:first_latest_cve, id: 'card_1')

  def first_cve
    cves[0]
  end

  def search_cve(query)
    self.query_input = query
    query_button
  end
end
