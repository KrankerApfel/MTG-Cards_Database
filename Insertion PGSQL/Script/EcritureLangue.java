import java.io.*;
import java.util.*;

public class EcritureLangue {
	 int carteID;

	 public EcritureLangue(){
		 carteID = 0;
	 }

	 public static String apostrophe(String texte) {
		String texteFinal = "";
		String[] texteTemp = texte.split("'");
		int i = 0;

		for(i = 0; i < texteTemp.length - 1; i++) {
			texteFinal += texteTemp[i] + "''";
		}
		texteFinal += texteTemp[i];
		return texteFinal;
	}

	 public void txtLangueToSGBD(String fichierALire, String fichierEcrit){
		try {

			BufferedReader lecture = new BufferedReader(new FileReader(fichierALire));
			BufferedWriter bw = new BufferedWriter(new FileWriter(fichierEcrit,true));

			bw.write("");

			String ligne = lecture.readLine();

			String ligneActuelle = "";
			String[] nom;
			String[] texteLigne;
			String texte = "";

			while(ligne != null) {
				if (ligne.contains("Card Name")) {
					nom = ligne.split("\t");
					ligneActuelle = "INSERT INTO carte_langue VALUES ('" + apostrophe(nom[1]) + "', ";
				}

				if (ligne.contains("Card Text:")) {
					texte = "";
					texteLigne = ligne.split("\t");
					texte += apostrophe(texteLigne[1]);

					ligne = lecture.readLine();
					while(!(ligne.contains("Flavor Text:"))) {
						texteLigne = ligne.split("\t");
						texte += apostrophe(texteLigne[2]);
						ligne = lecture.readLine();
					}
					
					ligneActuelle += "'" + texte + "', ";
					ligneActuelle += (++carteID) + ", 1);\n";

					bw.write(ligneActuelle);
				}

				ligne = lecture.readLine();
			}


			bw.close();
			lecture.close();
		}
		catch(IOException e) {
			System.out.println("Problème dans l'ouverture du fichier");
		}
	}

	public static void main(String[] args) {

		EcritureLangue magic = new EcritureLangue();
		magic.txtLangueToSGBD("odyssey.txt","carte_langue.sql");
		magic.txtLangueToSGBD("torment.txt","carte_langue.sql");
		magic.txtLangueToSGBD("judgement.txt","carte_langue.sql");

	}
	
}