/**
 * @file example.c
 * @author Eliot Coulon (eliot.coulon@reseau.eseo.fr)
 * @brief Header d'un driver CAN pour HAL STM32 simplifié dans le cadre d'exemple pour ProSE
 * @date 23-03-2023
 * @see example.h
 * @package Example
 * 
 * @copyright GPL V3.0
 */

#ifndef EXAMPLE_H_
#define EXAMPLE_H_

#include <stdint.h>
#include <stdbool.h>

/* ***************************************************** Public macros *************************************************** */
#define MASK_BITS                   0x700   /* Bits de masque */

/* Masque des cartes (des destinataires) */
#define BROADCAST_FILTER            0x000   /* Filtre de broadcast */
#define PROP_FILTER                 0x100   /* Filtre pour la propulsion */
#define STRAT_FILTER                0x200   /* Filtre pour la stratégie */
#define ACT_FILTER                  0x300   /* Filtre pour les actionneurs */
#define STEPPER_FILTER              0x380   /* Filtre pour la carte stepper (commande 4 moteurs) */

/**
 * @brief Macro qui vérifie si l'id CAN en paramètre correspond à un message dédié au simulateur
 * @param [in] p_sid L'identifiant sur 11 ou 29 bits à vérifier
 * @return true s'il s'agit d'un message pour le simulateur, false sinon
 */
#define IS_SIMU_FILTER(p_sid)       ((((uint32_t)p_sid) >= 0x760) && (((uint32_t)p_sid) <= 0x7FF))

/* ************************************************** Public type definition ********************************************* */
/* Remarque : l'énumération suivante est en fait un type (typedef) => nom suffixé par _e_t 
 * Si l'on a besoin de connaître le nombre d'élements de l'enum, un dernier énuméré peut être ajouté, suffixé par _COUNT */
/**
 * @brief Enumération des 4 moteurs pilotables
 */
typedef enum
{
    /* On documente chacun des champs de l'énumération avec 2 *, visible dans la Doxygen */
    /** Moteur 0 */
    STEPPER_MOTOR_0 = 0,
    /** Moteur 1 */
    STEPPER_MOTOR_1,
    /** Moteur 2 */
    STEPPER_MOTOR_2,
    /** Moteur 3 */
    STEPPER_MOTOR_3,
    /** Nombre de moteurs */
    STEPPER_MOTOR_COUNT
}stepper_motor_e_t;

/* Remarqe : définition d'un type structure => suffixé par _t */
/**
 * @brief Structure de données pour la commande d'un moteur pas à pas 
 */
typedef struct
{
    /* On documente chacun des champs de structure avec 2 *, visible dans la Doxygen */
    /** L'angle à atteindre en miliradiant (signé) */
    int32_t angle_mili_rad : 32;    
    /** Le motor à commander */
    stepper_motor_e_t motor : 2;      
}stepper_motor_set_goal_t;

/* Remarque : définition d'un type union => suffixé par _u_t */
/**
 * @brief Union de données pour la commande d'un moteur pas à pas 
 */
typedef union
{
    /** Données au format brut dans l'union */
    uint8_t raw_data[8];

    /* Remarque : structure anonyme pour l'accès aux données au format structuré => non suffixé */
    /**
     * @brief Structure anonyme correspondant à une demande de calibration d'un moteur pas à pas
     */
    struct
    {
        /** Le motor à calibrer */
        stepper_motor_e_t motor : 2;      
    }stepper_motor_calibrate;
}msg_can_formated_u_t;

/**
 * @brief Structure de données pour un message CAN
 */
typedef struct
{
    /** L'identifiant du message sur 11 ou 29 bits */
    uint32_t id;
    /** Les 8 octets de données formattés un utilisant un union */
    msg_can_formated_u_t data;
    /** Le nombre d'octets utiles du messages (Data Length Code)*/
    uint8_t size;
}can_msg_t;

/* **************************************************** Public functions ************************************************* */
/**
 * @brief Initialise le bus CAN
 * @return true si OK, false en cas de problème
 */
bool can_init(void);

/**
 * @brief Initialise un filtre CAN pour une configuration hardware single CAN
 * @param [in] mask_1 un premier masque sur lequel le filtre est appliqué (un ET bit à bit est
 *                      appliqué entre l'ID reçu et le masque)
 * @param [in] mask_2 un second masque (même rôle que le premier)
 * @param [in] filter_id_1 un premier filtre
 * @param [in] filter_id_2 un second filtre
 * @return true si en cas de succès (le masque est maintenant actif), false en cas d'échec
 * @warning En cas de mode double CAN, cette fonction n'est pas adaptée
 * @details Remplir un masque à 0 le rend inutile
 */
bool can_config_filter_single_can(int32_t mask_1, int32_t mask_2, int32_t filter_id_1, int32_t filter_id_2);

/**
 * @brief Reset le CAN, la queue des messages à envoyer et reçus
 */
void can_reset(void);

/**
 * @brief Envoi le message sur le bus
 * @param [in] p_can_msg pointeur sur le message à envoyer
 */
bool can_send(can_msg_t *p_can_msg);

/**
 * @brief Envoi un message vide (pas de contenu, seulement un ID)
 * @param [in] p_sid l'id du message
 */
bool can_send_sid(uint32_t p_sid);

/* *********************************************** Public callback functions ********************************************* */
/**
 * @brief Callback appelée lorsqu'une transmission sur la Mailbox 0 a fonctionné
 * @param [in,out] hcan Pointeur sur un CAN_HandleTypeDef qui contient la config CAN
 * @details Flags d'IT baissés automatiquement
 * @note Fonction appelée par HAL_CAN_IRQHandler et surchargée dans can.c, elle ne
 *       doit pas être appelée directement et son prototype ne doit pas être modifié.
 */
void HAL_CAN_TxMailbox0CompleteCallback(CAN_HandleTypeDef *hcan);

#endif /* EXAMPLE_H_ */
