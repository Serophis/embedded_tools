"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var peg = __importStar(require("./lib/peg-0.10.0.min.cjs"));
globalThis.peg = peg;
require("./lib/AnimUMLUtils.min.cjs");
var tsserverlibrary_js_1 = __importDefault(require("typescript/lib/tsserverlibrary.js"));
var typescript_template_language_service_decorator_1 = require("typescript-template-language-service-decorator");
function allVertices(region) {
    var _a;
    return Object.values((_a = region.stateByName) !== null && _a !== void 0 ? _a : {}).flatMap(function (e) {
        return __spreadArray([e], allVertices(e), true);
    });
}
function allStates(region) {
    return allVertices(region).filter(function (e) { return !e.kind; });
}
function allTransitions(region) {
    var _a;
    return __spreadArray(__spreadArray([], Object.values((_a = region.transitionByName) !== null && _a !== void 0 ? _a : {}), true), allStates(region).flatMap(function (e) {
        var _a, _b;
        return __spreadArray(__spreadArray([], Object.values((_a = e.transitionByName) !== null && _a !== void 0 ? _a : {}), true), Object.values((_b = e.internalTransitions) !== null && _b !== void 0 ? _b : {}), true);
    }), true);
}
;
;
function updateLocation(loc, outer) {
    var startLine = loc.start.line;
    return {
        start: {
            line: outer.start.line + startLine - 1,
            column: (startLine === 1 ? outer.start.column - 1 : 0) + loc.start.column,
            offset: outer.start.offset + loc.start.offset,
        },
        end: {
            offset: outer.start.offset + loc.end.offset,
        },
    };
}
//type KeyOfType<T, V> = keyof T;
/**/
/*
function test(state: ExtendedState, a: KeyOfType<ExtendedState, Location>) {
    type at = typeof a
    const b = state[a]
    const c: Location = state[a]
    const d: string = state[a]
    b
    c
    d
}
test
function test2<T extends {[P in keyof T]: T[P]}>(state: T, a: KeyOfType<T, Location>) {
    type at = typeof a
    const b = state[a]
    const c: Location = state[a]
    const d: string = state[a]
    b
    c
    d
}
test2
function test3<T extends {[P in keyof T]: T[P]}, V>(state: T, a: KeyOfType<T, V>) {
//function test3<T, V>(state: T, a: KeyOfType<T, V>) {
//function test3<T, V>(state: T, a: KeyOfType<T, V>) {
    type at = typeof a
    const b = state[a]
    const c: V = state[a]
    const d: string = state[a]
    b
    c
    d
}
test3
*/
function prettyLocation(loc, outer) {
    if (outer === void 0) { outer = undefined; }
    if (!loc)
        return "unknown location";
    var location = outer
        ? updateLocation(loc, outer)
        : loc;
    //if(outer) {
    //console.log("NOK:", JSON.stringify(location))
    //}
    var startLine = location.start.line;
    var startColumn = location.start.column;
    var length = location.end.offset - location.start.offset;
    return "Line ".concat(startLine, ", column ").concat(startColumn, " (").concat(length, " chars)");
}
var parsers = {
    classes: globalThis.AnimUMLUtils.classesParser,
    features: globalThis.AnimUMLUtils.featuresParser,
    behavior: globalThis.AnimUMLUtils.behaviorParser,
    method: {
        parse: function (s) {
            return globalThis.AnimUMLUtils.transformActions(adapt(s), {});
        },
    },
};
function parse(context) {
    var _a, _b;
    var n = context.node.parent.parent;
    if (tsserverlibrary_js_1.default.isPropertyAssignment(n)) {
        var parser_1 = undefined;
        var name_1 = undefined;
        if (tsserverlibrary_js_1.default.isIdentifier(n.name)) {
            name_1 = n.name.escapedText.toString();
            parser_1 = parsers[name_1];
        }
        else if (tsserverlibrary_js_1.default.isStringLiteral(n.name)) {
            name_1 = n.name.text.toString();
            parser_1 = parsers[name_1];
        }
        // TODO: what if interaction name is "behavior", or "classes"?
        if (!parser_1 && tsserverlibrary_js_1.default.isObjectLiteralExpression(n.parent) && tsserverlibrary_js_1.default.isPropertyAssignment(n.parent.parent)) {
            var ok = false;
            if (tsserverlibrary_js_1.default.isIdentifier(n.parent.parent.name)) {
                name_1 = n.parent.parent.name.escapedText.toString();
                ok = true;
            }
            else if (tsserverlibrary_js_1.default.isStringLiteral(n.parent.parent.name)) {
                name_1 = n.parent.parent.name.text.toString();
                ok = true;
            }
            if (ok && name_1 === "interactions") {
                parser_1 = globalThis.AnimUMLUtils.interactionParser;
            }
        }
        var locationUpdatingRules_1 = function (outer) {
            var _a;
            return (_a = {},
                _a[globalThis.AnimUMLUtils.defaultRule] = function (e, transfo) {
                    if (e.__location__) {
                        e.__location__ = updateLocation(e.__location__, outer);
                    }
                    return transfo(e);
                },
                _a);
        };
        if (parser_1) {
            parser_1.keepLocation = true;
            parser_1.warnings = [];
            //parser.warnings.push(`Line 1, column 1 (1 chars): warning: parsed`);
            try {
                var ast = parser_1.parse(context.text);
                if (name_1 === "behavior") {
                    //const processElement = <PropName extends string, RawPropName extends string, LocationPropName extends string, ParsedPropName extends string>(element: {[P: string]: typeof P extends PropName ? string : typeof P extends RawPropName ? string : typeof P extends LocationPropName ? Location : typeof P extends RawPropName ? any[] : never}, propName: PropName, rawPropName: RawPropName, locationPropName: LocationPropName, parsedPropName: ParsedPropName) => {
                    //const processElement = <T extends {[P in keyof T]: T[P]}>(element: T, propName: KeyOfType<T, string>, rawPropName: KeyOfType<T, string>, locationPropName: KeyOfType<T, Location>, parsedPropName: KeyOfType<T, any[]>) => {
                    var processElement = function (element, propName, rawPropName, locationPropName, parsedPropName) {
                        if (element[propName]) {
                            try {
                                var block = element[rawPropName]
                                    // to keep correct locations, but may break parsing?
                                    .replace(/\\/g, "\\")
                                    .replace(/\\n/g, "  ")
                                    .replace(/\\t/g, "  ");
                                var ast_1 = globalThis.AnimUMLUtils.transformActions(adapt(block), locationUpdatingRules_1(element[locationPropName]));
                                element[parsedPropName] = ast_1;
                            }
                            catch (e) {
                                if (e.constructor.name === "peg$SyntaxError") {
                                    parser_1.warnings.push("".concat(prettyLocation(e.location, element[locationPropName]), ": warning: ").concat(e.message));
                                }
                                else {
                                    // for debugging purposes
                                    parser_1.warnings.push("".concat(prettyLocation(element[locationPropName]), ": warning: ").concat(e.stack));
                                }
                            }
                        }
                    };
                    //const processState : (element: ExtendedState, propName: KeyOfType<ExtendedState, string>, rawPropName: KeyOfType<ExtendedState, string>, locationPropName: KeyOfType<ExtendedState, Location>, parsedPropName: KeyOfType<ExtendedState, any[]>) => void = processElement;
                    var processState = processElement;
                    // could not find a generic type, so resorting to this hack
                    var processTransition = processElement;
                    var allSt = allStates(ast);
                    for (var _i = 0, allSt_1 = allSt; _i < allSt_1.length; _i++) {
                        var state = allSt_1[_i];
                        processState(state, "entry", "__rawEntry__", "__entryLocation__", "parsedEntry");
                        processState(state, "exit", "__rawExit__", "__exitLocation__", "parsedExit");
                        processState(state, "doActivity", "__rawDoActivity__", "__doActivityLocation__", "parsedDoActivity");
                        /*
                        if(state.entry) {
                            try {
                                const entry = state.__rawEntry__
                                    // to keep correct locations, but may break parsing?
                                    .replace(/\\/g, "\\")
                                    .replace(/\\n/g, "  ")
                                    .replace(/\\t/g, "  ")
                                ;
                                const ast = globalThis.AnimUMLUtils.transformActions(adapt(entry), locationUpdatingRules(state.__entryLocation__));
                                state.parsedEntry = ast;
                            } catch(e) {
                                if(e.constructor.name === "peg$SyntaxError") {
                                    parser.warnings.push(`${prettyLocation(e.location, state.__entryLocation__)}: warning: ${e.message}`);
                                } else {
                                    // for debugging purposes
                                    parser.warnings.push(`${prettyLocation(state.__entryLocation__)}: warning: ${e.stack}`);
                                }
                            }
                        }
                        */
                    }
                    var allTrans = allTransitions(ast);
                    for (var _c = 0, allTrans_1 = allTrans; _c < allTrans_1.length; _c++) {
                        var trans = allTrans_1[_c];
                        processTransition(trans, "effect", "__rawEffect__", "__effectLocation__", "parsedEffect");
                        processTransition(trans, "guard", "__rawGuard__", "__guardLocation__", "parsedGuard");
                        //						if(trans.effect) {
                        //							try {
                        //								const effect = trans.__rawEffect__
                        //									// to keep correct locations, but may break parsing?
                        //									.replace(/\\/g, "\\")
                        //									.replace(/\\n/g, "  ")
                        //									.replace(/\\t/g, "  ")
                        //								;
                        //								const ast = globalThis.AnimUMLUtils.transformActions(adapt(effect), locationUpdatingRules(trans.__effectLocation__));
                        //								trans.parsedEffect = ast;
                        //							} catch(e) {
                        //								if(e.constructor.name === "peg$SyntaxError") {
                        //									/*
                        //									const outer = trans.__effectLocation__;
                        //									const startLine = e.location.start.line;
                        //									const location : Location = {
                        //										start: {
                        //											line: outer.start.line + startLine - 1,
                        //											column: (startLine === 1 ? outer.start.column : 0) + e.location.start.column,
                        //											offset: outer.start.offset + e.location.start.offset,
                        //										},
                        //										end: {
                        //											offset: outer.start.offset + e.location.end.offset,
                        //										},
                        //									};
                        //									console.log("OK:", JSON.stringify(location))
                        //									*/
                        //									parser.warnings.push(`${prettyLocation(e.location, trans.__effectLocation__)}: warning: ${e.message}`);
                        //								} else {
                        //									// for debugging purposes
                        //									parser.warnings.push(`${prettyLocation(trans.__location__)}: warning: ${e.stack}`);
                        //								}
                        //							}
                        //						}
                        if (trans.label) {
                            parser_1.warnings.push("".concat(prettyLocation(trans.__location__), ": warning: incorrect transition label"));
                        }
                        /*
                        if(trans.guard) {
                            try {
                                const guard = trans.__rawGuard__
                                    // to keep correct locations, but may break parsing?
                                    .replace(/\\/g, "\\")
                                    .replace(/\\n/g, "  ")
                                    .replace(/\\t/g, "  ")
                                ;
                                const ast = globalThis.AnimUMLUtils.transformExpression(adapt(guard), locationUpdatingRules(trans.__guardLocation__));
                                trans.parsedGuard = ast;
                                //parser.warnings.push(`${prettyLocation(trans.__guardLocation__)}: warning: ${JSON.stringify(ast)}`);
                            } catch(e) {
                                if(e.constructor.name === "peg$SyntaxError") {
                                    parser.warnings.push(`${prettyLocation(e.location, trans.__guardLocation__)}: warning: ${e.message}`);
                                } else {
                                    // for debugging purposes
                                    parser.warnings.push(`${prettyLocation(trans.__location__)}: warning: ${e.stack}`);
                                }
                            }
                        }
                        */
                    }
                }
                else if (name_1 === "classes" || name_1 === "features") {
                    var adaptedAst = name_1 === "features" ? { ast: ast } : ast;
                    for (var _d = 0, _e = Object.values(adaptedAst); _d < _e.length; _d++) {
                        var classifier = _e[_d];
                        for (var _f = 0, _g = Object.values((_a = classifier.operationByName) !== null && _a !== void 0 ? _a : {}); _f < _g.length; _f++) {
                            var op = _g[_f];
                            if (op.method) {
                                try {
                                    var ast_2 = globalThis.AnimUMLUtils.transformActions(adapt(op.method), locationUpdatingRules_1(op.__methodLocation__));
                                    op.parsedMethod = ast_2;
                                }
                                catch (e) {
                                    if (e.constructor.name === "peg$SyntaxError") {
                                        parser_1.warnings.push("".concat(prettyLocation(e.location, op.__methodLocation__), ": warning: ").concat(e.message));
                                    }
                                    else {
                                        parser_1.warnings.push("".concat(prettyLocation(op.__methodLocation__), ": warning: ").concat(e.stack));
                                    }
                                }
                            }
                        }
                    }
                }
                return {
                    name: name_1,
                    ast: ast,
                    diagnostics: parser_1.warnings.map(function (msg) {
                        var match = msg.match(/^Line ([0-9]+), column ([0-9]+) \(([0-9]+) chars\): warning: (.*)/s);
                        if (match) {
                            //console.log("HERE", match[1], match[2])
                            var pos = tsserverlibrary_js_1.default.getPositionOfLineAndCharacter({ text: context.text }, +match[1] - 1, +match[2] - 1);
                            //const lac = ts.getLineAndCharacterOfPosition({text: context.text} as ts.SourceFileLike, pos);
                            //fs.writeFileSync("/tmp/auls.log", `diag: ${+match[1]-1}:${+match[2]-1} => ${pos} => ${lac.line}:${lac.character}\n${new Error().stack}\n`, {flag: "a"});
                            return {
                                category: tsserverlibrary_js_1.default.DiagnosticCategory.Warning,
                                code: 1,
                                file: { fileName: context.fileName },
                                start: pos,
                                length: +match[3],
                                messageText: match[4],
                            };
                        }
                        else {
                            return {
                                category: tsserverlibrary_js_1.default.DiagnosticCategory.Warning,
                                code: 1,
                                file: undefined,
                                start: 0,
                                length: 1,
                                messageText: msg,
                            };
                        }
                    }),
                };
            }
            catch (e) {
                if (e.constructor.name === "peg$SyntaxError") {
                    if (e.location) {
                        var start = e.location.start;
                        var end = e.location.end;
                        /*
                        if(end.offset == start.offset) {
                            if(end.offset == context.text.length) {
                                start.offset--;
                            } else {
                                end.offset++;
                            }
                        }
                        */
                        return {
                            diagnostics: [{
                                    category: tsserverlibrary_js_1.default.DiagnosticCategory.Error,
                                    code: 1,
                                    file: undefined,
                                    start: start.offset,
                                    length: end.offset - start.offset,
                                    messageText: e.message, // + (e.stack ? ` at\n${e.stack}` : ""),
                                }],
                        };
                    }
                }
                else {
                    // for debugging purposes
                    return {
                        diagnostics: [{
                                category: tsserverlibrary_js_1.default.DiagnosticCategory.Error,
                                code: 1,
                                file: undefined,
                                start: 0,
                                length: 1,
                                messageText: "parsing error: ".concat((_b = e.stack) !== null && _b !== void 0 ? _b : e),
                            }],
                    };
                }
            }
        }
        else {
            return {
                diagnostics: [{
                        start: 0,
                        length: 1,
                        category: tsserverlibrary_js_1.default.DiagnosticCategory.Error,
                        code: 1,
                        file: undefined,
                        messageText: "unknown syntax: ".concat(name_1),
                    }],
            };
        }
    }
    else {
        return {
            diagnostics: [],
        };
    }
}
var AnimUMLTemplateLanguageService = /** @class */ (function () {
    function AnimUMLTemplateLanguageService() {
    }
    // hover
    AnimUMLTemplateLanguageService.prototype.getQuickInfoAtPosition = function (context, position) {
        var _a;
        var ast = parse(context).ast;
        var target = ast;
        //fs.writeFileSync("/tmp/auls.log", `getQuickInfoAtPosition: ${position.line}:${position.character}\n${new Error().stack}\n`, {flag: "a"});
        var pos = tsserverlibrary_js_1.default.getPositionOfLineAndCharacter({ text: context.text }, position.line, position.character);
        //fs.writeFileSync("/tmp/auls.log", `getQuickInfoAtPosition: ${position.line}:${position.character} => ${pos}\n${new Error().stack}\n`, {flag: "a"});
        globalThis.AnimUMLUtils.transform(ast, (_a = {},
            _a[globalThis.AnimUMLUtils.defaultRule] = function (e, trans) {
                if (e.__location__ && pos >= e.__location__.start.offset && pos < e.__location__.end.offset) {
                    target = e;
                }
                trans(e);
            },
            _a));
        return {
            kind: tsserverlibrary_js_1.default.ScriptElementKind.unknown,
            kindModifiers: "nothing",
            textSpan: {
                start: pos,
                length: 1,
            },
            //displayParts?: SymbolDisplayPart[];
            documentation: [
                {
                    text: "line ".concat(position.line, ", character ").concat(position.character, " => position ").concat(pos),
                    kind: "position",
                },
                {
                    text: JSON.stringify(target, null, 2),
                    kind: "ast",
                }
            ],
            //tags?: JSDocTagInfo[];
        };
    };
    AnimUMLTemplateLanguageService.prototype.getSyntacticDiagnostics = function (context) {
        var _a;
        /*
        const seen = new Map();
        let id = 0;
        const v = JSON.stringify(context.node.parent.parent, (_key, value) => {
            if(typeof value === "object") {
                if(seen.has(value)) {
                    return {__ref__: seen.get(value)};
                } else {
                    seen.set(value, id);
                    return {...value, __id__: id++};
                }
            } else {
                return value;
            }
        }, 2);
        fs.writeFileSync("/tmp/auls.log", v);
        */
        return (_a = parse(context).diagnostics) !== null && _a !== void 0 ? _a : [];
        /*
        return [{
        //	reportsUnnecessary?: {};
        //	reportsDeprecated?: {};
        //	source?: string;
            //relatedInformation: [],
            category: ts.DiagnosticCategory.Warning,
            code: 1,
            file: undefined,
            start: 5,
            length: 5,
            messageText: "test message",
        }];
        */
    };
    AnimUMLTemplateLanguageService.prototype.getCompletionsAtPosition = function (context, position) {
        var line = context.text.split(/\n/g)[position.line];
        return {
            isGlobalCompletion: false,
            isMemberCompletion: false,
            isNewIdentifierLocation: false,
            entries: [
                {
                    name: line.slice(0, position.character),
                    // @ts-ignore
                    kind: "",
                    kindModifiers: 'echo',
                    sortText: 'echo'
                }
            ]
        };
    };
    AnimUMLTemplateLanguageService.prototype.getOutliningSpans = function (context) {
        var _a = parse(context), name = _a.name, ast = _a.ast;
        if (name === "classes") {
            return Object.entries(ast).map(function (_a) {
                var clName = _a[0], cl = _a[1];
                var start = cl.__location__.start.offset;
                var span = {
                    start: start,
                    length: cl.__location__.end.offset - start,
                };
                return {
                    textSpan: span,
                    hintSpan: span,
                    bannerText: clName,
                    autoCollapse: false,
                    kind: tsserverlibrary_js_1.default.OutliningSpanKind.Code,
                };
            });
        }
        return [];
    };
    return AnimUMLTemplateLanguageService;
}());
function adapt(s) {
    return s
        .replace(/::/g, ".");
}
module.exports = function (mod) {
    return {
        create: function (info) {
            return (0, typescript_template_language_service_decorator_1.decorateWithTemplateLanguageService)(mod.typescript, info.languageService, info.project, new AnimUMLTemplateLanguageService(), { tags: ['raw'] });
        }
    };
};
