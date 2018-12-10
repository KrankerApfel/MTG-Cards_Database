import java.util.Scanner;
import java.io.*;
import java.util.*;

public class Ecriture {

	private int counter;

	public Ecriture(){
		counter = 0;
	}

	private static String conversion(String coutAnglais) {
		if(coutAnglais.equals("Land") || coutAnglais.equals("n/a"))
			return "T";
		String[] tabCout = coutAnglais.split("");
		String coutFrancais = "";
		for(int i = 0; i < tabCout.length; i++) {
			switch(tabCout[i]) {
				case "U": tabCout[i] = "B";break;
				case "B": tabCout[i] = "N";break;
				case "R": tabCout[i] = "R";break;
				case "G": tabCout[i] = "V";break;
			}
			coutFrancais += tabCout[i];
		}

		return coutFrancais;
	}

	public void txtToSGBD(String fichierALire, String fichierEcrit){
		try {
			BufferedReader lecture = new BufferedReader(new FileReader(fichierALire));
			BufferedWriter bw = new BufferedWriter(new FileWriter(fichierEcrit, true));

			String ligne;
			String ecriture = "";
			bw.write(ecriture);
			String cout = "";
			String[] tabSplit;
			String[] atkDef;
			String[] number;
			String[] type;
			ligne = lecture.readLine();
			String ligneActuelle = "";
			char couleur = 'a';

			while(ligne != null) {
				if (ligne.startsWith("Card Name")){
					counter++;
					ligneActuelle = "INSERT INTO carte_virtuelle (carte_id, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_artiste, carte_rarete, carte_ordre_serie, ser_code) VALUES ("+counter+", ";
				}else if(ligne.startsWith("Card Color")) {
					couleur = ligne.charAt(ligne.length() - 1);
					switch(couleur) {
						case 'W': ligneActuelle += "'W', ";break;
						case 'U': ligneActuelle += "'B', ";break;
						case 'B': ligneActuelle += "'N', ";break;
						case 'R': ligneActuelle += "'R', ";break;
						case 'G': ligneActuelle += "'V', ";break;
						case 'Z': ligneActuelle += "'M', ";break;
						case 'A': ligneActuelle += "'I', ";break;
						default: ligneActuelle += "'T', "; break;
					}
				}
				else if(ligne.startsWith("Mana Cost")) {
					System.out.println(counter + ligne);
					tabSplit = ligne.split("\t");
					cout = conversion(tabSplit[1]);
				}
				else if(ligne.startsWith("Type")) {
					tabSplit = ligne.split("\t");
					type = tabSplit[1].split(" ");
					switch(type[0]) {
						case "Sorcery": ligneActuelle += "'rituel', " + "'" + cout + "', "; break;
						case "Enchantment": ligneActuelle += "'enchantement', " + "'" + cout + "', "; break; 
						case "Enchant": ligneActuelle += "'enchantement', " + "'" + cout + "', "; break;
						case "Instant": ligneActuelle += "'éphémère', " + "'" + cout + "', "; break;
						case "Land": ligneActuelle += "'terrain', " + "'" + cout + "', "; break;
						case "Artifact": ligneActuelle += "'artefact', " + "'" + cout + "', "; break;
						default: ligneActuelle += "'créature', " + "'" + cout + "', "; break;
					}
				}
				else if(ligne.startsWith("Pow/Tou")) {
					tabSplit = ligne.split("\t");
					if(tabSplit.length == 2) {
						atkDef = tabSplit[1].split("/");
						if(atkDef[0].equals("*"))
							ligneActuelle += "-1, ";
						else if(atkDef[0].equals("n"))
							ligneActuelle += "NULL, ";
						else
							ligneActuelle += atkDef[0] + ", ";
						if(atkDef[1].equals("*"))
							ligneActuelle += "-1, ";
						else if(atkDef[1].equals("a"))
							ligneActuelle += "NULL, ";
						else
							ligneActuelle += atkDef[1] + ", ";
						//ligneActuelle += atkDef[0] + ", " + atkDef[1] + ", ";
					}
					else
						ligneActuelle += " NULL, NULL, ";
				}
				else if(ligne.startsWith("Artist")) {
					tabSplit = ligne.split("\t");
					if(tabSplit.length == 3) {
						//System.out.println(tabSplit[2]);
						ligneActuelle += "'" + tabSplit[2] + "', ";
					}
				}
				else if(ligne.startsWith("Rarity")) {
					tabSplit = ligne.split("\t");
					if(tabSplit.length == 3) {
						switch(tabSplit[2]) {
							case "L": 
							case "C": ligneActuelle += "0, "; break;
							case "U": ligneActuelle += "1, "; break;
							case "R": ligneActuelle += "2, "; break;
							case "M": ligneActuelle += "3, "; break;
							default: ligneActuelle += "4, "; break;
						}
					}
				}
				else if(ligne.startsWith("Card #")) {
					String ser_code ="";
					tabSplit = ligne.split("\t");
					number = tabSplit[2].split("/");
					if(fichierALire.startsWith("odyssey"))
						ser_code = "ODY";
					else if(fichierALire.startsWith("torment"))
						ser_code = "TOR";
					else if(fichierALire.startsWith("judgement"))
						ser_code = "JUD";
					ligneActuelle += number[0] + ", '"+ ser_code +"'); \n";
					ecriture += ligneActuelle;
					bw.write(ligneActuelle);
				}
				ligne = lecture.readLine();
				//System.out.println("coucou" + ligneActuelle);
			}

			System.out.println(ecriture);

			//bw.write(ecriture);

			lecture.close();
			bw.close();
		}
		catch(IOException e) {
			System.out.println("Problème dans l'ouverture du fichier");
		}

	}
	public static void main(String[] args) {
		Ecriture magic = new Ecriture();
		magic.txtToSGBD("odyssey.txt","carte_virtuelle.sql");
		magic.txtToSGBD("torment.txt","carte_virtuelle.sql");
		magic.txtToSGBD("judgement.txt", "carte_virtuelle.sql");
	}

	
}