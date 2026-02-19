let selectedCharId = null;
let selectedNation = null;

// LÓGICA DE EVENTOS
window.addEventListener('message', function(event) {
    if (event.data.action === 'openUI') {
        $('body').show();
        $('#app').css('background', 'rgba(0, 0, 0, 0.6)');
        $('#app').fadeIn(500).css('display', 'flex');
        $('#selection-screen').show();
        
        $('#creator-form').hide();
        $('#delete-modal').hide();
        $('#skin-creator').hide(); 
        
        setupCharacters(event.data.characters);
    }
    if (event.data.action === 'openSkinCreator') {
        openSkinCreator();
    }
});

// ZOOM & FOCO
window.addEventListener('wheel', function(event) {
    if ($('#skin-creator').is(':visible')) {
        let dir = event.deltaY > 0 ? -1 : 1;
        $.post('https://sov_core/zoomCam', JSON.stringify({ dir: dir }));
    }
});

window.addEventListener('contextmenu', function(e) {
    if ($('#skin-creator').is(':visible')) {
        e.preventDefault();
        $.post('https://sov_core/toggleCamFocus', JSON.stringify({}));
    }
});

function showNotify(msg, type = 'error') {
    let id = Date.now();
    let html = `<div id="${id}" class="toast ${type}">${msg}</div>`;
    $('#toast-container').append(html);
    setTimeout(() => { $(`#${id}`).fadeOut(400, function(){ $(this).remove(); }); }, 3500);
}

document.getElementById('birthdate').addEventListener('input', function (e) {
    let v = e.target.value.replace(/\D/g, ''); 
    if (v.length > 8) v = v.slice(0, 8);
    if (v.length >= 5) {
        v = v.replace(/^(\d{2})(\d{2})(\d{0,4}).*/, '$1/$2/$3');
    } else if (v.length >= 3) {
        v = v.replace(/^(\d{2})(\d{0,2}).*/, '$1/$2');
    }
    e.target.value = v;
});

// SELEÇÃO & CRUD
function setupCharacters(chars) {
    $('#char-list').html('');
    selectedCharId = null;
    $('#char-actions').hide(); // Esconde menu de ação

    chars.forEach(char => {
        // Ícone dinâmico baseada no gênero
        let icon = char.gender === 'Female' ? '👩' : '👨';
        
        let html = `
        <div class="char-card" onclick="selectChar(this, ${char.id}, '${char.name} ${char.surname}', '${char.bank}')">
            <div class="card-avatar">
                <div class="emoji">${icon}</div>
            </div>
            <div class="card-info">
                <h3>${char.name}<br>${char.surname}</h3>
                <small>ID CIDADÃO: ${char.id}</small>
            </div>
        </div>`;
        $('#char-list').append(html);
    });

    // LIMITE DE 3 PERSONAGENS
    if (chars.length >= 3) {
        $('#btn-create-char').hide();
    } else {
        $('#btn-create-char').show().css('display', 'flex');
    }
}

function selectChar(element, id, name, bank) {
    $('.char-card').removeClass('active');
    $(element).addClass('active');
    selectedCharId = id;
    
    $('#sel-name').text(name);
    $('#sel-bank').text(`$${parseInt(bank).toLocaleString()}`);
    $('#char-actions').fadeIn(); // Mostra menu
}

function playCharacter() {
    if(!selectedCharId) return showNotify("Selecione um perfil primeiro.");
    $('#app').fadeOut(300, () => { $.post('https://sov_core/selectCharacter', JSON.stringify({ id: selectedCharId })); });
}

function askDelete() { if(selectedCharId) $('#delete-modal').fadeIn(300).css('display', 'flex'); }
function cancelDelete() { $('#delete-modal').fadeOut(300); }
function executeDelete() {
    $.post('https://sov_core/deleteCharacter', JSON.stringify({ id: selectedCharId }));
    $('#delete-modal').fadeOut(300);
}

// CRIAÇÃO DE DADOS
function openCreator() {
    selectedCharId = null; 
    $('.char-card').removeClass('active');
    $('#char-actions').hide();
    
    $('#delete-modal').hide(); 
    $('#selection-screen').hide();
    $('#creator-form').fadeIn(400).css('display', 'flex');
    
    $('#firstname').val(''); $('#lastname').val(''); $('#birthdate').val('');
    selectedNation = null; $('.nation-opt').removeClass('active');
}

function selectNation(id) {
    selectedNation = id; 
    $('.nation-opt').removeClass('active');
    $(`.nation-opt:nth-child(${id})`).addClass('active');
}

function backToMenu() { $('#creator-form').hide(); $('#selection-screen').fadeIn(400); }

function submitCreate() {
    const data = {
        firstname: $('#firstname').val().trim(),
        lastname: $('#lastname').val().trim(),
        birthdate: $('#birthdate').val().trim(),
        nation: selectedNation
    };
    if(!data.firstname || !data.lastname || data.birthdate.length < 10) return showNotify("Preencha todos os campos.");
    if(!selectedNation) return showNotify("Escolha uma nacionalidade.");
    
    $('#creator-form').fadeOut(300);
    $.post('https://sov_core/finishCharacterCreation', JSON.stringify(data));
}

// --- SKIN CREATOR V5.0 ---
let currentGender = 'Male';
let appearance = { top: 1, legs: 1, shoes: 1, hair: 0, beard: 0 };
let skinFeatures = { mix: 0.5, face1: 0, face2: 0, skinColor: 0, eyeColor: 0, eyebrowStyle: 0, lipstick: 255, lipstickColor: 0, features: Array(20).fill(0.0) };
let rotateInterval = null;

function openSkinCreator() {
    $('#app').css('background', 'transparent').show(); 
    $('#creator-form').hide();
    $('#selection-screen').hide();
    $('#skin-creator').fadeIn(600);
    
    $('input[type=range]').val(0); 
    setTab('genetics');
    setGender('Male');
}

function setTab(tabName) {
    $('.tab').removeClass('active');
    $(`.tab[data-target="${tabName}"]`).addClass('active');
    $('.tab-page').hide();
    $(`#tab-${tabName}`).fadeIn(300);
    
    if(tabName === 'face' || tabName === 'hair') {
        $.post('https://sov_core/toggleCamFocus', JSON.stringify({ force: 'face' }));
    } else {
        $.post('https://sov_core/toggleCamFocus', JSON.stringify({ force: 'body' }));
    }
}

function setGender(gender) {
    currentGender = gender;
    $('.g-btn').removeClass('active');
    if(gender === 'Male') {
        $('.g-btn:first').addClass('active');
        skinFeatures.mix = 0.0;
        skinFeatures.face1 = 0; skinFeatures.face2 = 0;
    } else {
        $('.g-btn:last').addClass('active');
        skinFeatures.mix = 0.5;
        skinFeatures.face1 = 0; skinFeatures.face2 = 0;
    }
    updateLabels();
    updatePreview();
}

function changeParent(type, dir) {
    let max = 21; 
    skinFeatures[type] += dir;
    if(skinFeatures[type] > max) skinFeatures[type] = 0;
    if(skinFeatures[type] < 0) skinFeatures[type] = max;
    updateLabels();
    updatePreview();
}

function updateDNA(val) { skinFeatures.mix = parseFloat(val); updatePreview(); }

function updateFeature(idx, val) {
    if(idx === 'skin') skinFeatures.skinColor = parseInt(val);
    else if(idx === 'eyeColor') skinFeatures.eyeColor = parseInt(val);
    else if(idx === 'eyebrowStyle') skinFeatures.eyebrowStyle = parseInt(val);
    else if(idx === 'lipstick') skinFeatures.lipstick = parseInt(val);
    else if(idx === 'lipstickColor') skinFeatures.lipstickColor = parseInt(val);
    else skinFeatures.features[idx] = parseFloat(val);
    updatePreview();
}

function changeApp(part, dir) {
    appearance[part] += dir;
    let max = (part === 'hair' || part === 'beard') ? 70 : 10;
    if(appearance[part] > max) appearance[part] = 0;
    if(appearance[part] < 0) appearance[part] = max;
    updateLabels();
    updatePreview();
}

function updateLabels() {
    $(`#lbl-face1`).text(skinFeatures.face1);
    $(`#lbl-face2`).text(skinFeatures.face2);
    $(`#lbl-hair`).text(appearance.hair);
    $(`#lbl-beard`).text(appearance.beard);
    $(`#lbl-top`).text(appearance.top);
    $(`#lbl-legs`).text(appearance.legs);
    $(`#lbl-shoes`).text(appearance.shoes);
}

function updatePreview() {
    let model = (currentGender === 'Female') ? 'mp_f_freemode_01' : 'mp_m_freemode_01';
    $.post('https://sov_core/updateSkinPreview', JSON.stringify({ model: model, appearance: appearance, skinData: skinFeatures }));
}

function startRotate(dir) {
    if(rotateInterval) clearInterval(rotateInterval);
    rotateInterval = setInterval(() => { $.post('https://sov_core/rotateChar', JSON.stringify({ dir: dir })); }, 30);
}
function stopRotate() { clearInterval(rotateInterval); }

function saveSkin() {
    $('#app').fadeOut(500);
    $.post('https://sov_core/saveSkin', JSON.stringify({ gender: currentGender, appearance: appearance, features: skinFeatures }));
}