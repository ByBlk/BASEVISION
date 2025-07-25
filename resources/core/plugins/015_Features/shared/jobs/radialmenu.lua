VFW.Jobs.RadialMenu = {
    lspd = {
        main = {
            {
                name = "APPEL DE RENFORT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/police_logo.svg",
                action = "MakeRenfortCall",
            },
            {
                name = "PAPIERS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = "OpenSubRadialJobs",
                args = "papiers"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty",
            },
            {
                name = "ACTIONS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/police.svg",
                action = "OpenSubRadialJobs",
                args = "actions"
            }
        },
        actions = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "CIRCULATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/road.svg",
                action = "OpenCerculationenu"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "OBJETS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "MenuJobsObjet"
            },
            {
                name = "BRACELET",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "ToggleBracelet"
            },
        },
        papiers = {
            {
                name = "CONVOCATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/top_paper.svg",
                action = ""
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "DEPOSITION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = ""
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            }
        },
    },
    lssd = {
        main = {
            {
                name = "APPEL DE RENFORT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/police_logo.svg",
                action = "MakeRenfortCall",
            },
            {
                name = "PAPIERS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = "OpenSubRadialJobs",
                args = "papiers"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty",
            },
            {
                name = "ACTIONS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/police.svg",
                action = "OpenSubRadialJobs",
                args = "actions"
            }
        },
        actions = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "CIRCULATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/road.svg",
                action = "OpenCerculationenu"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "OBJETS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "MenuJobsObjet"
            },
        },
        papiers = {
            {
                name = "CONVOCATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/top_paper.svg",
                action = ""
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "DEPOSITION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = ""
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            }
        },
    },
    sams = {
        main = {
            {
                name = "APPEL DE RENFORT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/pharmacy.svg",
                action = "MakeRenfortCall"
            },
            {
                name = "PAPIERS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/bpm.svg",
                action = "OpenSubRadialJobs",
                args = "papiers"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty"
            },
            {
                name = "ACTIONS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/player.svg",
                action = "OpenSubRadialJobs",
                args = "objets"
            }
        },
        papiers = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "CERTIFICAT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/health_paper.svg",
                action = ""
            }
        },
        objets = {
            {
                name = "OBJETS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "MenuJobsObjet"
            },
            {
                name = "BRANCARD",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/health_tool.svg",
                action = "ToggleBrancard"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            }
        },
    },
    usss = {
        main = {
            {
                name = "APPEL DE RENFORT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/police_logo.svg",
                action = "MakeRenfortCall"
            },
            {
                name = "PAPIERS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = "",
                args = "papiers"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty"
            },
            {
                name = "ACTIONS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/police.svg",
                action = "OpenSubRadialJobs",
                args = "actions"
            }
        },
        papiers = {
            {
                name = "CONVOCATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/top_paper.svg",
                action = ""
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "DEPOSITION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = ""
            }
        },
        actions = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "CIRCULATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/road.svg",
                action = "OpenCerculationenu"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "OBJETS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "MenuJobsObjet"
            }
        }
    },
    lsfd = {
        main = {
            {
                name = "APPEL DE RENFORT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/pharmacy.svg",
                action = "MakeRenfortCall"
            },
            {
                name = "PAPIERS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/bpm.svg",
                action = "OpenSubRadialJobs",
                args = "papiers"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty"
            },
            {
                name = "ACTIONS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/fire_extinguisher.svg",
                action = "OpenSubRadialJobs",
                args = "actions"
            }
        },
        papiers = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "CERTIFICAT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/health_paper.svg",
                action = ""
            }
        },
        actions = {
            {
                name = "CIRCULATION",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/road.svg",
                action = "OpenCerculationenu"
            },
            {
                name = "OBJETS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "OpenSubRadialJobs",
                args = "objets"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "INCENDIE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/fire_station.svg",
                action = ""
            },
        },
        objets = {
            {
                name = "OBJETS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/object.svg",
                action = "MenuJobsObjet"
            },
            {
                name = "BRANCARD",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/health_tool.svg",
                action = "ToggleBrancard"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "actions"
            }
        },
        incendie = {
            {
                name = "LANCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/fire_extinguisher.svg",
                action = "ToggleHose"
            },
            {
                name = "MOUSSE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/repair.svg",
                action = "ToggleFoam"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "actions"
            },
        }
    },
    gouv = {
        main = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice",
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty"
            },
            {
                name = "CONTRAT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = "",
            }
        },
    },
    doj = {
        main = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice",
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty"
            },
            {
                name = "CONTRAT",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/paper.svg",
                action = "",
            }
        },
    },
    dynasty = {
        main = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty"
            },
            {
                name = "PROPRIÉTÉ",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/house.svg",
                action = "OpenPropertyCreationMenu"
            }
        }
    },
}
