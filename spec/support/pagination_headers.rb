module ApiHeaders
  def pagination_headers
    header 'Link', type: :string, description: 'Link pagination'
    header 'X-Page-Count', type: :integer, description: 'Total page count'
    header 'X-Current-Page', type: :integer, description: 'Current page number'
    header 'X-Page-Size', type: :integer, description: 'Item count in the current page'
    header 'X-Total', type: :integer, description: 'Total number of items'
  end
end
