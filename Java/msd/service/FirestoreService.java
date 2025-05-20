package com.example.msd.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.cloud.firestore.Firestore;

@Service
public class FirestoreService {

	private final Firestore firestore;
	
	@Autowired
	public FirestoreService(Firestore firestore) {
		this.firestore = firestore;
	}
}
