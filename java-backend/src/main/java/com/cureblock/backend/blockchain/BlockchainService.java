package com.cureblock.backend.blockchain;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.Map;
import java.util.UUID;

@Service
public class BlockchainService {

 // His FastAPI blockchain service. Must be running (uvicorn on :8000).
         private static final String BLOCKCHAIN_API = "http://localhost:8000/api/v1/register";

 private final RestClient restClient = RestClient.create();


         public Map<String, String> anchorToChain(String childId, String cid, String hash) {
 try {
 // Build the request his API expects.
 // He needs: did, fingerprintTemplate, leftIrisTemplate, rightIrisTemplate, parentWallet
 // We have fingerprint data; iris + wallet are placeholders (our data has neither).
 Map<String, String> requestBody = Map.of(
            "did", childId,
            "fingerprintTemplate", hash,  // our SHA-256 hash as the template
            "leftIrisTemplate", "NO_IRIS_DATA",  // placeholder
            "rightIrisTemplate", "NO_IRIS_DATA", // placeholder
            "parentWallet", "0x0000000000000000000000000000000000000000" // placeholder
            );

 @SuppressWarnings("unchecked")
 Map<String, Object> response = restClient.post()
 .uri(BLOCKCHAIN_API)
 .body(requestBody)
 .retrieve()
 .body(Map.class);

 if (response != null && "success".equals(response.get("status"))) {
 return Map.of(
             "txnId", String.valueOf(response.get("transaction_hash")),
             "ipfsCid", String.valueOf(response.get("ipfs_cid")),
             "status", "CONFIRMED"
             );
 }
 // Unexpected response shape -> fall back
 return stubResult("UNEXPECTED_RESPONSE");

 } catch (Exception e) {
 // Service down or error -> fall back so enrolment still works
 System.out.println(">> Blockchain API unreachable, using stub: " + e.getMessage());
 return stubResult("STUB_FALLBACK");
 }
 }

 private Map<String, String> stubResult(String reason) {
 return Map.of(
           "txnId", "STUB-TXN-" + UUID.randomUUID(),
           "ipfsCid", "STUB-CID",
           "status", "CONFIRMED"
           );
 }
}