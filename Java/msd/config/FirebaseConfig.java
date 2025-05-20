package com.example.msd.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.cloud.firestore.Firestore;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Configuration
public class FirebaseConfig{
	
	@Bean
	public Firestore initializeFireBase()throws IOException{
	  FileInputStream serviceAccount = new FileInputStream("src/main/resources/movie-seriesdiary-firebase-adminsdk-fbsvc-7382de38c4.json");
				
	  
		FirebaseOptions options = FirebaseOptions.builder()
				.setCredentials(GoogleCredentials.fromStream(serviceAccount))
				.build();
		
		if(FirebaseApp.getApps().isEmpty()) {
			FirebaseApp.initializeApp(options);
			System.out.println("Firebase bağlantısı başarılı");
		}
		return FirestoreClient.getFirestore(); 
	
	}

}
