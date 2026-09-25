const INPUT_PTR = 1024;
const OUTPUT_PTRS = [4096, 4608, 5120];
const MAX_INPUT_BYTES = 256;

let wasm = null;

const phraseInput = document.querySelector("#phrase");
const generateBtn = document.querySelector("#generateBtn");
const generatedPassword = document.querySelector("#generatedPassword");
const resultBox = document.querySelector("#resultBox");
const wasmStatus = document.querySelector("#wasmStatus");

const passwordInput = document.querySelector("#passwordInput");
const strength = document.querySelector("#strength");

const encoder = new TextEncoder();
const decoder = new TextDecoder();

function random_u32() {
  const values = new Uint32Array(1);
  crypto.getRandomValues(values);
  return values[0];
}

function normalizeToAscii(text) {
  return text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/ß/g, "ss")
    .replace(/Æ/g, "AE")
    .replace(/æ/g, "ae")
    .replace(/Ø/g, "O")
    .replace(/ø/g, "o")
    .replace(/Ł/g, "L")
    .replace(/ł/g, "l")
    .replace(/[^\x20-\x7E]/g, "");
}

async function loadWasm() {
  try {
    const response = await fetch("./main.wasm");

    if (!response.ok) {
      throw new Error(`No se pudo cargar main.wasm (${response.status})`);
    }

    const bytes = await response.arrayBuffer();

    const { instance } = await WebAssembly.instantiate(bytes, {
      env: {
        random_u32,
      },
    });

    wasm = instance.exports;

    if (!wasm.memory || !wasm.pwd_gen) {
      throw new Error("main.wasm no exporta memory o pwd_gen.");
    }

    wasmStatus.textContent = "WASM listo";
    wasmStatus.className = "status ready";
    generateBtn.disabled = false;
  } catch (error) {
    console.error(error);

    wasmStatus.textContent = "Error al cargar";
    wasmStatus.className = "status error";
  }
}

function generateOnePassword(inputBytes, outputPtr) {
  const memory = new Uint8Array(wasm.memory.buffer);

  memory.set(inputBytes, INPUT_PTR);

  const outputLength = wasm.pwd_gen(
    INPUT_PTR,
    inputBytes.length,
    outputPtr
  );

  const outputBytes = new Uint8Array(
    wasm.memory.buffer,
    outputPtr,
    outputLength
  );

  return decoder.decode(outputBytes);
}

function createPasswordCard(password, index) {
  const card = document.createElement("div");

  card.style.display = "flex";
  card.style.alignItems = "center";
  card.style.justifyContent = "space-between";
  card.style.gap = "16px";
  card.style.padding = "16px";
  card.style.marginBottom = "12px";
  card.style.border = "1px solid #303846";
  card.style.borderRadius = "12px";
  card.style.background = "#11161d";

  const content = document.createElement("div");

  content.style.display = "flex";
  content.style.flexDirection = "column";
  content.style.gap = "5px";
  content.style.minWidth = "0";

  const label = document.createElement("span");

  label.textContent = `Opción ${index + 1}`;

  label.style.fontSize = "12px";
  label.style.fontWeight = "700";
  label.style.color = "#7f8a9a";
  label.style.textTransform = "uppercase";
  label.style.letterSpacing = "0.08em";

  const value = document.createElement("code");

  value.textContent = password;

  value.style.fontSize = "16px";
  value.style.color = "#f4f7fb";
  value.style.overflowWrap = "anywhere";

  const copyButton = document.createElement("button");

  copyButton.type = "button";
  copyButton.textContent = "Copiar";
  copyButton.className = "secondary";

  copyButton.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(password);

      copyButton.textContent = "Copiado";

      setTimeout(() => {
        copyButton.textContent = "Copiar";
      }, 1200);
    } catch {
      copyButton.textContent = "Error";
    }
  });

  content.append(label, value);
  card.append(content, copyButton);

  return card;
}

function generatePasswords() {
  if (!wasm) return;

  const normalized = normalizeToAscii(
    phraseInput.value.trim()
  );

  if (!normalized) {
    generatedPassword.textContent =
      "Escribe una frase primero.";

    resultBox.classList.remove("hidden");
    return;
  }

  const inputBytes = encoder.encode(normalized);

  if (inputBytes.length > MAX_INPUT_BYTES) {
    generatedPassword.textContent =
      `La frase es demasiado larga. Máximo: ${MAX_INPUT_BYTES} bytes.`;

    resultBox.classList.remove("hidden");
    return;
  }

  const passwords = OUTPUT_PTRS.map((outputPtr) =>
    generateOnePassword(inputBytes, outputPtr)
  );

  generatedPassword.innerHTML = "";

  passwords.forEach((password, index) => {
    const card = createPasswordCard(
      password,
      index
    );

    generatedPassword.appendChild(card);
  });

  resultBox.classList.remove("hidden");
}

function setRule(id, valid) {
  const element = document.querySelector(id);
  const indicator = element.querySelector(".indicator");

  element.classList.toggle("valid", valid);

  indicator.textContent =
    valid ? "✓" : "×";
}

function validatePassword(password) {
  const checks = {
    length: password.length >= 12,

    upper:
      /[A-Z]/.test(password),

    lower:
      /[a-z]/.test(password),

    number:
      /[0-9]/.test(password),

    symbol:
      /[^A-Za-z0-9]/.test(password),
  };

  setRule("#ruleLength", checks.length);
  setRule("#ruleUpper", checks.upper);
  setRule("#ruleLower", checks.lower);
  setRule("#ruleNumber", checks.number);
  setRule("#ruleSymbol", checks.symbol);

  const valid =
    Object.values(checks).every(Boolean);

  strength.textContent = valid
    ? "La contraseña cumple todas las reglas"
    : "La contraseña todavía no cumple todas las reglas";

  strength.className =
    `strength ${valid ? "good" : "bad"}`;
}

generateBtn.addEventListener(
  "click",
  generatePasswords
);

phraseInput.addEventListener(
  "keydown",
  (event) => {
    if (
      event.key === "Enter" &&
      !generateBtn.disabled
    ) {
      generatePasswords();
    }
  }
);

passwordInput.addEventListener(
  "input",
  () => {
    validatePassword(
      passwordInput.value
    );
  }
);

validatePassword("");

loadWasm();
