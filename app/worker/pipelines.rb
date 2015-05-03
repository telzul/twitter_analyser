Superworker.define :DiscussionPipeline, :url do
  ParseThreadId :url
  LoadThread :url
  AnalyseSentiments :url
  FinaliseDiscussion :url
end