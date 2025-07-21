function setGradientColor(id, color1, color2) {
    document.getElementById(`${id}-stop-1`).setAttribute("stop-color", color1);
    document.getElementById(`${id}-stop-2`).setAttribute("stop-color", color2);
}

function setGlowColor(color) {
    let filter = document.querySelector("#glow feGaussianBlur");
    filter.setAttribute("stdDeviation", "8");
    let mergeNode = document.querySelector("#glow feMergeNode");
    mergeNode.setAttribute("style", `filter: drop-shadow(0px 0px 10px ${color});`);
}

function setInteraction(data) {
    const interactElement = document.getElementById('interact');
    if (data.visible) {
        interactElement.classList.add('visible');
    } else {
        interactElement.classList.remove('visible');
        document.querySelector('.label').style.opacity = 0.0;
        return;
    }
    document.getElementById('key-text').textContent = data.key;
    document.getElementById('label-text').textContent = data.label;
    document.querySelector('.key > p').style.background = data.keyColor;
    document.querySelector('.key > p').style.webkitBackgroundClip = 'text';
    document.querySelector('.key > p').style.webkitTextFillColor = 'transparent';
    if (data.labelOpacity) {
        document.querySelector('.label').style.opacity = data.labelOpacity;
    }
    document.querySelector('.key').style.background = `linear-gradient(to bottom, ${data.labelGradientStart}, ${data.labelGradientEnd})`
    document.getElementById('icon-img').src = `https://cdn.eltrane.cloud/alkiarp/assets/interacts/${data.icons}.svg`;
}

function setPointVisibility(data) {
    if (data.visible) {
        document.getElementById('point').style.opacity = 1;
        setGradientColor("gradient2", data.innerGradientStart, data.innerGradientEnd);
        setGradientColor("gradient", data.outerStrokeStart, data.outerStrokeEnd);
        setGlowColor(data.glowColor);
    } else {
        document.getElementById('point').style.opacity = 0;
        return;
    }
}

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type === 'setInteraction') {
        setInteraction(data.data);
    } else if (data.type === 'setPointVisibility') {
        setPointVisibility(data.data);
    }
});