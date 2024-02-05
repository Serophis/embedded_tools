/**
 * @file Example.java
 * @author Eliot Coulon (eliot.coulon@reseau.eseo.fr)
 * @brief Classe Ligne, utilisée comme exemple pour la génération de la documentation ProSE
 * @date 23-03-2023
 * @package fr.eseo.pdlo.projet.artiste.modele.formes
 * 
 * @copyright GPL V3.0
 */

package fr.eseo.pdlo.projet.artiste.modele.formes;

import java.text.DecimalFormat;
import java.util.Locale;
import fr.eseo.pdlo.projet.artiste.modele.Coordonnees;

/**
 * @class Ligne
 * @brief Modèle d'une Ligne qui hérite de la classe Forme avec ses attributs et méthodes
 */
public class Ligne extends Forme {
    /**
     * @brief Attribut static EPSILON utilisé par la méthode contient
     */
    public static final double EPSILON = 0.2;

    /**
     * @brief Constructeur par défaut de la classe Ligne
     */
    public Ligne() {
        super();
    }

    /**
     * @brief Constructeur de la classe Ligne à une position donnée avec largeur et hauteur par défaut
     * @param position Coordonnées du point C1
     * @overload Ligne()
     */
    public Ligne(Coordonnees position) {
        super(position);
    }

    /**
     * @brief Constructeur de la classe Ligne en (0,0) avec largeur et hauteur
     * @param largeur Abscisse du point C1
     * @param hauteur Ordonnée du point C1
     * @overload Ligne()
     */
    public Ligne(double largeur, double hauteur) {
        super(largeur, hauteur);
    }

    /**
     * @brief Constructeur de la classe Ligne à une position donnée avec largeur et hauteur
     * @param position Coordonnées du point C1
     * @param largeur  Largeur de la ligne
     * @param hauteur  Hauteur de la ligne
     * @overload Ligne(Coordonees position)
     */
    public Ligne(Coordonnees position, double largeur, double hauteur) {
        super(position, largeur, hauteur);
    }

    /**
     * @brief Constructeur de la classe Ligne à une position donnée avec largeur et hauteur
     * @param x       Abscisse du point C1
     * @param y       Ordonnée du point C1
     * @param largeur Largeur de la ligne
     * @param hauteur Hauteur de la ligne
     * @overload Ligne(Coordonees position, double largeur, double hauteur)
     */
    public Ligne(double x, double y, double largeur, double hauteur) {
        super(x, y, largeur, hauteur);
    }

    /**
     * @brief Méthode permettant de récupérer le point C1
     * @return Coordonnées du point C1
     */
    public Coordonnees getC1() {
        return this.getPosition();
    }

    /**
     * @brief Méthode permettant de récupérer le point C2
     * @return Coordonnées du point C2
     */
    public Coordonnees getC2() {
        Coordonnees c2 = new Coordonnees(this.getC1().getAbscisse() + this.getLargeur(),
                this.getC1().getOrdonnee() + this.getHauteur());
        return (c2);
    }

    /**
     * @brief Méthode permettant de déplacer le point C1
     * @param position Coordonnées du point C1
     */
    public void setC1(Coordonnees position) {
        this.setLargeur(this.getC2().getAbscisse() - position.getAbscisse());
        this.setHauteur(this.getC2().getOrdonnee() - position.getOrdonnee());
        this.setPosition(position);
    }

    /**
     * @brief Méthode permettant de déplacer le point C2
     * @param position Coordonnées du point C2
     */
    public void setC2(Coordonnees position) {
        this.setLargeur(position.getAbscisse() - this.getC1().getAbscisse());
        this.setHauteur(position.getOrdonnee() - this.getC1().getOrdonnee());
    }

    /**
     * @brief Méthode permettant de calculer l'aire de la ligne
     * @return 0 étant donné que la ligne n'a pas d'aire
     */
    @Override
    public double aire() {
        return 0;
    }

    /**
     * @brief Méthode permettant de calculer le périmètre de la ligne
     * @return Distance entre C1 et C2
     */
    @Override
    public double perimetre() {
        return this.getC1().distanceVers(this.getC2());
    }

    /**
     * @brief Méthode permettant de savoir si un point est contenu dans la ligne à EPSILON près
     * @param coordonnees Coordonnées du point à tester
     * @return true si le point est contenu dans la ligne, false sinon
     */
    @Override
    public boolean contient(Coordonnees coordonnees) {
        // Distance entre C1 et le point donné
        double d1 = this.getC1().distanceVers(coordonnees);
        // Distance entre C2 et le point donné
        double d2 = this.getC2().distanceVers(coordonnees);
        // Comparaison somme distances par rapport à la distance entre C1 et C2
        return (d1 + d2 - this.getC1().distanceVers(getC2())) <= Ligne.EPSILON;
    }
}