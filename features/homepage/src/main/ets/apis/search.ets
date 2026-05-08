import { RequestRemoteCommunication, SearchParams, SearchResult } from "basic";

export const getSearchResultApi = (params: SearchParams) => RequestRemoteCommunication.post<SearchResult>("/search/all", params)
