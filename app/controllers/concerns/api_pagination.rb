# frozen_string_literal: true

# == Handle Header based pagination with pagy gem ==
# Information about pagination is provided in the Link header.

# @note
#  - Using the "Link" header allows you to return pagination information in a compact and efficient format,
#    without having to include it in the body of the response. This is useful when the response body may be large and bandwidth is a concern.
#  - The "Link" header is a standard way to express pagination links, which makes it easy for client-side code to parse
#    and follow the links, such as automatically fetch the next page of data.

# @see
#    reference: https://docs.github.com/en/rest/guides/using-pagination-in-the-rest-api?apiVersion=2022-11-28

module ApiPagination
  include ::Pagy::Backend

  #  Set pagination on Headers:
  #     --------
  #     X-Page-Count: Total page count
  #     X-Current-Page: Current page number
  #     X-Page-Size: Item count in the current page
  #     X-Total: Total number of items

  #     Link: previous, next, first & last links.
  #           See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Link
  def pagination_headers(pagy)
    links = (headers['Link'] || '').split(',').map(&:strip)

    headers['Link'] = build_pagy_links(pagy, links)
    headers['X-Page-Count'] = pagy.pages
    headers['X-Current-Page'] = pagy.page
    headers['X-Page-Size'] = pagy.items
    headers['X-Total'] = pagy.count
  end

  private

  # build navigation link with pagy
  def build_pagy_links(pagy, links)
    # clean up url from parameters
    clean_url = request.original_url.sub(/\?.*$/, '')
    paging_info = pages(pagy)

    paging_info.each do |key, value|
      query_params = request.query_parameters.merge(page: value)
      links << %( <#{clean_url}?#{query_params.to_param}>; rel="#{key}" )
    end

    links.join(', ') unless links.empty?
  end

  def pages(pagy)
    {}.tap do |paging|
      paging[:first] = 1
      paging[:last] = pagy.pages

      paging[:prev] = pagy.prev unless pagy.prev.nil?
      paging[:next] = pagy.next unless pagy.next.nil?
    end
  end
end
