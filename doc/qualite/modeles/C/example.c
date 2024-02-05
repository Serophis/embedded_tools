/**
 * @file example.c
 * @author Eliot Coulon (eliot.coulon@reseau.eseo.fr)
 * @brief Source d'un module d'exemple de code inutile (rien à voir avec le module CAN, des choses
 *        différentes sont montrées ici)
 * @date 23-03-2023
 * @see example.h
 * @package Example
 * 
 * @copyright GPL V3.0
 */

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

/* Note : l'utilisation de commentaires sont la forme // est interdite, il faut utiliser la forme
   /* ... */ /* pour les commentaires de blocs */
/* Remarque : structure point_t dans le .h non fourni car cette structure est publique mais il n'y a
 * pas de .h pour cet exemple.*/

/* **************************************************** Private macros *************************************************** */
/**
 * @brief Exemple de taille d'un tableau
 */
#define TAB_SIZE (10U)

/* ************************************************* Private type definition ********************************************* */
/**
 * @brief Exemple de pointeur sur fonction qui prend deux paramètres et ne retourne rien
 */
void (*function_pointer_example_t)(uint8_t, uint16_t);

/* **************************************************** Private variables ************************************************ */
/* Remarque : préfixe s_ pour les variables statiques du module */
static uint8_t s_useless_var = 0;
/* Remarque : préfixe s_c_ pour static const */
static const uint16_t s_c_size = TAB_SIZE;
/* Remarque : préfixe s_v_ pour static volatile */
static volatile uint8_t s_v_useless_var = 0;

/* ********************************************* Private functions prototypes ******************************************** */
/* Remarque : prototypes des fonctions privées */
/**
 * @brief Fonction inutile qui montre qu'il faut tout de même documenter une fonction privée dans
 *        sa déclaration.
 */
static void useless_function(void);

/* *************************************************** Private functions ************************************************* */
/* Remarque : implémentation des fonctions privées */
static void useless_function(void) 
{
    /* Remarque : NA */
}

/* **************************************************** Public functions ************************************************* */
/* Remarque : documentation des fonctions externes supposée dans le header correspondant, non 
   applicable pour cet exemple étant donné que le .h ne correspond par au .c */
point_t *point_new() 
{
    /* Remarque : allocation et reset mémoire (calloc pour mettre à 0 tous les octets alloués) */
    point_t *l_this = (point_t * )(calloc(1, sizeof(point_t)));
    /* Remarque : test du resultat sur une ligne différente */
    if(l_this == NULL) 
    {
        /* Remarque : affichage du code d'erreur de errno et du message d'erreur associé */
        perror("point_new : calloc failed");
    }
    return l_this;
}

/* Remarque : la docoumentation de cette fonction dans son header serait par exemple : */
/**
 * @brief Fonction qui libère la mémoire allouée pour un point
 * @param [in,out] p_point Pointeur sur le point_t à libérer
 * @pre Le pointeur ne doit pas être NULL
 */
void point_free(point_t *p_point) 
{
    /* @pre On vérifie que le pointeur n'est pas NULL */
    assert(p_point != NULL);
    free(p_point);
    *p_point = NULL;
}

/* Remarque : la docoumentation de cette fonction dans son header serait par exemple : */
/**
 * @brief Fonction qui additionne les coordonnées de deux points
 * @param [in] p_point_a Pointeur sur le premier point
 * @param [in] p_point_b Pointeur sur le second point
 * @param [in] p_point_c Pointeur sur le point résultat
 * @pre Les pointeurs ne doivent pas être NULL
 * @post Les coordonnées du point résultat sont les coordonnées de la somme des deux autres points
 * @invariant Les coordonnées des points ne sont pas modifiées
 */
void point_add(const point_t *p_point_a, const point_t *p_point_b, point_t *p_point_c) 
{
    /* @pre On vérifie que les pointeurs ne sont pas NULL */
    assert(p_point_a != NULL);
    assert(p_point_b != NULL);
    assert(p_point_c != NULL);
    p_point_c->x = p_point_a->x + p_point_b->x;
    p_point_c->y = p_point_a->y + p_point_b->y;
    /* @post Vérification des post conditions en utilisant un autre moyen de calcul */
    assert((p_point_c->x - p_point_a->x) == p_point_b->x);
    assert((p_point_c->y - p_point_a->y) == p_point_b->y);
}

/* Remarque : la documentation de cette fonction dans son header serait par exemple : */
/**
 * @brief Fonction affiche les coordonnées d'un tableau de points pour former une figure
 * @param [in] p_point Pointeur sur le point à afficher
 * @param [in] p_point_count Nombre de points à afficher
 * @pre p_point ne doit pas être NULL
 */
void point_display_figure(const point_t *p_point, const uint8_t p_point_count) 
{
    /* Remarque : ici, "const" remplace une éventuelle postcondition de non modification de 
       p_point */
    /* @pre On vérifie que le pointeur n'est pas NULL */
    assert(p_point != NULL);
    /* Remarque : respecter la syntaxe du for, les accolades sont obligatoires, même pour une seule 
       ligne ! Notez la position des espaces et des accolades */
    for(uint8_t l_i = 0; l_i < p_point_count; l_i++)
    {
        printf("point %d : (%d, %d)", l_i, p_point[l_i].x, p_point[l_i].y);
    }
}

/* *********************************************** Public callback functions ********************************************* */
/* Implémentation des fonctions de callback appelées par d'autres modules */