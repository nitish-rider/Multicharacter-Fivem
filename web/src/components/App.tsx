import React, {useEffect, useState} from "react";
import "./App.css";
import {debugData} from "../utils/debugData";
import {ScrollArea, Transition} from '@mantine/core';
import {useNuiEvent} from "../hooks/useNuiEvent";
import {fetchNui} from "../utils/fetchNui";
import ReactFlagsSelect from "react-flags-select";
import {DatePickerInput} from '@mantine/dates';
import {countries} from "./FetchCountrybyCode";
import dayjs from 'dayjs';
import customParseFormat from 'dayjs/plugin/customParseFormat';

dayjs.extend(customParseFormat);
debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

export default function App() {
    const [isLoading, setIsLoading] = useState(false);
    const [isContainerOpen, setIsContainerOpen] = useState(false);
    const [opened, setOpened] = useState(false);

    const [value, setValue] = useState<Date | null>(null);
    const maxWordLimit = 300; // Set your desired word limit
    const [defaultcharslot, setDefaultcharslot] = useState(0);
    const [charslot, setCharslot] = useState(0);
    const [characterData, setCharacterData] = useState<any>([]);
    const [firstname, setFirstname] = useState("");
    const [secondname, setSecondname] = useState("");
    const [gender, setGender] = useState("male");
    const [height, setHeight] = useState("");
    const [selectedcountry, setSelectedCountry] = useState<string>();
    const [country, setCountry] = useState('')
    const [dob, setDob] = useState<any>();
    const [backstory, setBackstory] = useState(""); // State to store textarea value
    const [cid, setCid] = useState<number>();
    const [deletebuttonon, setDeletebuttonon] = useState(false);
    const [deletererun, setDeleteRerun] = useState(false);
    const [runnn, setRunnn] = useState(false);
    useEffect(() => {

        fetchNui('cDataPed', {cData: characterData[0]?.citizenid});
    }, [runnn]);

    const handleBackstoryChange = (event: any) => {
        const inputText = event.target.value;
        const words = inputText.split(/\s+/); // Split words by space
        const wordCount = words.length;
        if (wordCount <= maxWordLimit) {
            setBackstory(inputText);
        }
    };
    useNuiEvent('setupCharacters', (data: any) => {
        setCharacterData(data);
    })
    useNuiEvent("setVisible", (data: any) => {
        setOpened(data?.toggle);
        setDefaultcharslot(data?.defaultCharCount);
        setCharslot(data?.mySlotCount);
        setDeletebuttonon(data?.enableDeleteButton);
        if (data?.toggle) {
            fetchNui("started", {});
            setIsLoading(true);
        }
    })
    useNuiEvent("DeleteAlert", (data: any) => {

        setDeleteRerun(true);
    })
    useEffect(() => {
        if (deletererun) {
            setTimeout(() => {
                setIsLoading(false);
                setDeleteRerun(false);
            }, 7000);
        }
    }, [deletererun])
    useEffect(() => {
        setTimeout(() => {
            setIsLoading(false);
        }, 5000);

    }, [opened]);
    const handleGenderChange = (event: any) => {
        const selectedGender = event.target.value;
        fetchNui('cDataPed', {sex: selectedGender})
        setGender(selectedGender); // You can do something with the selected gender here
    };

    function hasWhiteSpace(s: any) {
        return /\s/g.test(s);
    }

    return (
        <Transition
            mounted={opened}
            transition="fade"
            duration={300}
            timingFunction="linear"
        >
            {(styles) => <div className="nui-wrapper" style={styles}>
                <div>
                    {isLoading ? (
                        <div className="Loadingscreen">
                            <div className="background">
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                            </div>
                            <svg
                                className="ip"
                                viewBox="0 0 256 128"
                                width="256px"
                                height="128px"
                                xmlns="http://www.w3.org/2000/svg"
                            >
                                <defs>
                                    <linearGradient id="grad1" x1="0" y1="0" x2="1" y2="0">
                                        <stop offset="0%" stop-color="#5ebd3e"/>
                                        <stop offset="33%" stop-color="#ffb900"/>
                                        <stop offset="67%" stop-color="#f78200"/>
                                        <stop offset="100%" stop-color="#e23838"/>
                                    </linearGradient>
                                    <linearGradient id="grad2" x1="1" y1="0" x2="0" y2="0">
                                        <stop offset="0%" stop-color="#e23838"/>
                                        <stop offset="33%" stop-color="#973999"/>
                                        <stop offset="67%" stop-color="#009cdf"/>
                                        <stop offset="100%" stop-color="#5ebd3e"/>
                                    </linearGradient>
                                </defs>
                                <g fill="none" stroke-linecap="round" stroke-width="16">
                                    <g className="ip__track" stroke="#ddd">
                                        <path d="M8,64s0-56,60-56,60,112,120,112,60-56,60-56"/>
                                        <path d="M248,64s0-56-60-56-60,112-120,112S8,64,8,64"/>
                                    </g>
                                    <g stroke-dasharray="180 656">
                                        <path
                                            className="ip__worm1"
                                            stroke="url(#grad1)"
                                            stroke-dashoffset="0"
                                            d="M8,64s0-56,60-56,60,112,120,112,60-56,60-56"
                                        />
                                        <path
                                            className="ip__worm2"
                                            stroke="url(#grad2)"
                                            stroke-dashoffset="358"
                                            d="M248,64s0-56-60-56-60,112-120,112S8,64,8,64"
                                        />
                                    </g>
                                </g>
                            </svg>
                        </div>
                    ) : (
                        <div>
                            <div className="container-left">
                                <div className="container-left-heading">
                                    <span>Character</span>
                                    <span>Selection</span>
                                </div>
                                <div className="container-left-subheading">
                                    Choose Which Character You Wanna Play
                                </div>
                                <ScrollArea scrollbars='y' className="slots-list">
                                    {[...Array(defaultcharslot)].map((_, index) => {
                                        const isSlotOpen = index < charslot; // Check if the slot is open
                                        const hasCharacterData = characterData[index]; // Check if character data is available for this slot
                                        setRunnn(true);
                                        return (
                                            <>
                                                {hasCharacterData ? (
                                                    <div key={index}>
                                                        <div onClick={() => {
                                                            fetchNui('cDataPed', {cData: characterData[index]?.citizenid});
                                                            setIsContainerOpen(false)
                                                        }} className={`slot ${isSlotOpen ? 'open' : 'locked'}`}>
                                                            <div className="bg_images"></div>
                                                            <div
                                                                className="citizen-id">{characterData[index]?.citizenid}</div>
                                                            <div
                                                                className="character-name">{characterData[index]?.charinfo?.firstname} {characterData[index]?.charinfo?.lastname}</div>
                                                            <div
                                                                className="character-job">{characterData[index]?.job?.label}</div>
                                                        </div>
                                                        <div className="buttons-main">
                                                            <button onClick={() => {
                                                                fetchNui('cDataPed', {cData: characterData[index]?.citizenid}).then(() => {
                                                                    fetchNui("selectCharacter", {cData: characterData[index]?.citizenid});
                                                                })
                                                            }} className="Btn">
                                                                <div className="sign">
                                                                    <i className="fa-duotone fa-turn-down-left fa-flip-horizontal"></i>
                                                                </div>
                                                                <div className="text">Start</div>
                                                            </button>
                                                            {deletebuttonon && <button onClick={() => {
                                                                fetchNui('removeCharacter', {citizenid: characterData[index]?.citizenid})
                                                                setIsLoading(true);
                                                            }} className="Btn" id="button_delete_Bg">
                                                                <div className="sign">
                                                                    <i className="fa-duotone fa-trash"
                                                                       id="button_delete"></i>
                                                                </div>
                                                                <div className="text" id="button_delete_text">
                                                                    Remove
                                                                </div>
                                                            </button>}

                                                        </div>

                                                    </div>
                                                ) : <div onClick={() => {
                                                    setCid(index + 1);
                                                    fetchNui('cDataPed', {cData: characterData[index]?.citizenid})
                                                }} className="slot open">
                                                    <div
                                                        className="create-slot"
                                                        onClick={() => {
                                                            setIsContainerOpen(true);
                                                        }}
                                                    >
                                                        <i className="fa-duotone fa-user-plus"></i>
                                                        <div className="create-name">Create Character</div>
                                                    </div>
                                                </div>}
                                            </>
                                        );
                                    })}
                                </ScrollArea>

                            </div>
                            <Transition
                                mounted={isContainerOpen}
                                transition="fade"
                                duration={411}
                                timingFunction="ease-in-out"
                            >
                                {(styles) => <div className="container-reg" style={styles}>
                                    <div className="container-reg-header">Character Registration</div>
                                    <div className="cr_Firstname">
                                        <input onChange={(e) => {
                                            setFirstname(e.target.value)
                                        }} type="text" className="cr_Firstname_Input"/>
                                        <div className="cr_Firstname_name">First Name</div>
                                    </div>
                                    <div className="cr_Secondname">
                                        <input onChange={(e) => {
                                            setSecondname(e.target.value)
                                        }} type="text" className="cr_Secondname_Input"/>
                                        <div className="cr_secondname_name">Second Name</div>
                                    </div>
                                    <ReactFlagsSelect
                                        className="cr_Nationality"
                                        selected={country}
                                        onSelect={(country) => {
                                            setCountry(country);
                                            setSelectedCountry(countries[country])
                                        }}
                                        showOptionLabel={true}
                                    />
                                    <div className="cr_Nationality_name">Nationality</div>
                                    <div className="cr_Gender">
                                        <div className="Gender-select">
                                            <select onChange={(e) => handleGenderChange(e)}>
                                                <option value="male">Male</option>
                                                <option value="female">Female</option>
                                            </select>
                                        </div>
                                        <div className="cr_Gender_name">Gender</div>
                                    </div>

                                    <div className="cr_Height">
                                        <input type="text" onChange={(e) => {
                                            setHeight(e.target.value)
                                        }} className="cr_Height_Input"/>
                                        <div className="cr_Height_name">Height</div>
                                    </div>

                                    <div className="cr_Deb">
                                        <div className="ChuttiyaSala">
                                            <DatePickerInput
                                                className="cr_Deb_Input"
                                                value={value}
                                                onChange={(e) => {
                                                    setValue(e);
                                                    setDob(dayjs(e).format('DD/MM/YYYY'))
                                                }}
                                            />
                                        </div>
                                        <div className="cr_Deb_name">Date Of Birth</div>
                                    </div>

                                    <div className="cr_Backstory">
                    <textarea
                        className="cr_Backstory_Input"
                        value={backstory}
                        onChange={handleBackstoryChange}
                    ></textarea>
                                        <div className="cr_Backstory_name">Backstory</div>
                                        <div className="word-limit-info">
                                            {backstory.split(/\s+/).filter((word) => word !== "").length}/{maxWordLimit}
                                        </div>
                                    </div>
                                    <div className="buttons-reg-main">
                                        <button onClick={() => {
                                            if (hasWhiteSpace(firstname) || hasWhiteSpace(secondname) || firstname === "" || secondname === "" || gender === "" || height === "" || selectedcountry === "" || dob === "" || backstory === "") {
                                                return;
                                            }
                                            if (height > '200' || height < '150') {
                                                return;
                                            }
                                            fetchNui('createNewCharacter', {
                                                firstname: firstname,
                                                lastname: secondname,
                                                nationality: selectedcountry,
                                                birthdate: dob,
                                                height: height,
                                                gender: gender,
                                                backstory: backstory,
                                                cid: cid,
                                            }).then(() => {
                                                setIsContainerOpen(false);
                                                setFirstname("");
                                                setSecondname("");
                                                setSelectedCountry('');
                                                setDob("");
                                                setHeight("");
                                                setGender('');
                                                setBackstory("");
                                            })
                                        }} className="Btn">
                                            <div className="sign">
                                                <i className="fa-duotone fa-check"></i>
                                            </div>
                                            <div className="text">Create</div>
                                        </button>
                                        <button onClick={() => {
                                            setIsContainerOpen(false);
                                        }} className="Btn" id="button_reg_delete_Bg">
                                            <div className="sign">
                                                <i className="fa-solid fa-xmark" id="button_reg_delete"></i>
                                            </div>
                                            <div className="text" id="button_reg_delete_text">Cancel</div>
                                        </button>
                                    </div>
                                </div>}
                            </Transition>
                        </div>
                    )}
                </div>
            </div>}

        </Transition>
    );
}